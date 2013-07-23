require 'runcible'
require 'logging'

module Content::Orchestration::Pulp
  extend ActiveSupport::Concern

  included do
    attr_reader :pulp
    after_validation :initialize_pulp, :queue_pulp
    before_destroy :initialize_pulp, :queue_pulp_destroy unless Rails.env == "test"
  end

  def pulp?
    @use_pulp ||= Setting.use_pulp and enabled?
  end

  def sync_status
    Runcible::Extensions::Repository.sync_status(pulp_id) if pulp? && pulp_id
  end

  protected

  def initialize_pulp
    return unless pulp?
    self.pulp_id       ||= Foreman.uuid.gsub("-", '')
    self.relative_path ||= custom_repo_path("acme_org", "library", product.name, name)

    Runcible::Base.config = runcible_config
  end

  def queue_pulp
    return unless pulp? and errors.empty?
    new_record? ? queue_pulp_create : queue_pulp_update
  end

  private

  def queue_pulp_create
    logger.debug "Scheduling new Pulp Repository"
    queue.create(:name   => _("Create Pulp Repository for %s") % self, :priority => 10,
                 :action => [self, :set_pulp_repo])
    queue.create(:name   => _("Sync Pulp Repository %s") % self, :priority => 20,
                 :action => [self, :set_sync_pulp_repo])
  end

  def set_pulp_repo
    Runcible::Extensions::Repository.create_with_importer_and_distributors(pulp_id,
                                                                           pulp_importer,
                                                                           [pulp_distributor],
                                                                           { :display_name => relative_path,
                                                                             :description  => description })
  end

  def del_pulp_repo
    Runcible::Resources::Repository.delete(pulp_id)
  end

  def set_sync_pulp_repo
    Runcible::Resources::Repository.sync(pulp_id)
  end

  def del_sync_pulp_repo
    status = sync_status
    return if status.blank? || status.state == ::PulpSyncStatus::Status::NOT_SYNCED
    Runcible::Resources::Task.cancel(status.uuid)
  end

  def pulp_importer
    options = {
      #:ssl_ca_cert     => feed_ca,
      #:ssl_client_cert => feed_cert,
      #:ssl_client_key  => feed_key,
      :feed_url => feed
    }

    case content_type
      when Content::Repository::YUM_TYPE
        Runcible::Extensions::YumImporter.new(options)
      when Content::Repository::FILE_TYPE
        Runcible::Extensions::IsoImporter.new(options)
      else
        raise "Unexpected repo type %s" % content_type
    end
  end

  def pulp_distributor
    case content_type
      when Content::Repository::YUM_TYPE
        Runcible::Extensions::YumDistributor.new(relative_path, unprotected, true,
                                                 { :protected    => true, :id => pulp_id,
                                                   :auto_publish => true })
      when Content::Repository::FILE_TYPE
        dist              = Runcible::Extensions::IsoDistributor.new(true, true)
        dist.auto_publish = true
        dist
      else
        raise "Unexpected repo type %s" % content_type
    end
  end

  def runcible_config
    {
      :url          => "https://amos-dev.sat.lab.tlv.redhat.com",
      :api_path     => "/pulp/api/v2/",
      :user         => "admin",
      :timeout      => 60,
      :open_timeout => 60,
      :oauth        => { :oauth_secret => "+7cs4WhVrTM7D+kgQv98Qbnt3wO096pB",
                         :oauth_key    => "katello" },
      :logging      => { :logger    => ::Logging.logger['pulp_rest'],
                         :exception => true,
                         :debug     => true }
    }
  end

  def queue_pulp_destroy
    return unless pulp? and errors.empty?
    logger.debug _("Scheduling removal of Pulp Repository %s") % name
    queue.create(:name => _("Delete Pulp repository for %s") % name, :priority => 50,
                 :action => [self, :del_pulp_repo])
  end
end
