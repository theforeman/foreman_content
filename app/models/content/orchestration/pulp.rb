module Content::Orchestration::Pulp
  extend ActiveSupport::Concern

  included do
    after_validation :queue_pulp
    before_destroy :queue_pulp_destroy unless Rails.env == "test"
  end

  def orchestration_errors?
    errors.empty?
  end

  protected

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

  def queue_pulp_update
  end

  def set_pulp_repo
    Content::Pulp.extentions.repository.create_with_importer_and_distributors(pulp_id,
                                                                           pulp_importer,
                                                                           [pulp_distributor],
                                                                           { :display_name => relative_path,
                                                                             :description  => description })
  rescue RestClient::BadRequest => e
    raise (JSON.parse e.response)['error_message']
  end

  def del_pulp_repo
    delete
  end

  def set_sync_pulp_repo
    sync
  end

  def del_sync_pulp_repo
    status = sync_status
    return if status.blank? || status == ::PulpSyncStatus::Status::NOT_SYNCED
    Content::Pulp.resources.task.cancel(status.uuid)
  end

  def pulp_importer
    options = {
      :feed_url => feed
    }

    case content_type
      when Content::Repository::YUM_TYPE, Content::Repository::KICKSTART_TYPE
        Runcible::Extensions::YumImporter.new(options)
      when Content::Repository::FILE_TYPE
        Runcible::Extensions::IsoImporter.new(options)
      else
        raise "Unexpected repo type %s" % content_type
    end
  end

  def pulp_distributor
    case content_type
      when Content::Repository::YUM_TYPE, Content::Repository::KICKSTART_TYPE
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

  def queue_pulp_destroy
    return unless pulp? and errors.empty?
    logger.debug _("Scheduling removal of Pulp Repository %s") % name
    queue.create(:name => _("Delete Pulp repository for %s") % name, :priority => 50,
                 :action => [self, :del_pulp_repo])
  end
end
