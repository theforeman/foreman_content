module Content::Orchestration::RepositoryClone
  extend ActiveSupport::Concern
  include ::Orchestration

  included do
    after_validation :repository_clone_save  unless Rails.env == "test"
    before_destroy :repository_clone_destroy unless Rails.env == "test"
    delegate :last_sync, :sync_status, :sync, :counters, :last_publish, :sync_history, :state, :to => :repo
  end

  def orchestration_errors?
    errors.empty?
  end

  def pulp?
    @use_pulp ||= Setting.use_pulp and enabled?
  end

  private

  def repository_clone_save
    return unless (pulp? and errors.empty? and new_record?)
     queue_pulp_create
  end

  def queue_pulp_create
    logger.debug "Scheduling new Pulp Repository"
    queue.create(:name   => _("Create Pulp Repository for %s") % self, :priority => 10,
                 :action => [self, :set_pulp_repo])
    queue.create(:name   => _("Copy Pulp Repository %s") % self, :priority => 20,
                 :action => [self, :set_copy_pulp_repo])
    queue.create(:name   => _("Create Event Notifier") % self, :priority => 30,
                 :action => [self, :set_create_event_notifier])
    queue.create(:name   => _("Publish Pulp Repository %s") % self, :priority => 40,
                 :action => [self, :set_publish_pulp_repo])
  end

  def repository_clone_destroy
    return unless pulp? and errors.empty?
    logger.debug _("Scheduling removal of Pulp Repository %s") % name
    queue.create(:name   => _("Delete Pulp repository for %s") % name, :priority => 50,
                 :action => [self, :del_pulp_repo])
  end

  def set_pulp_repo
    Runcible::Resources::EventNotifier
    repo.create
  end

  def set_copy_pulp_repo
    repo.copy_from(repository.pulp_id)
  end

  def set_publish_pulp_repo
    repo.publish
  end

  # TODO: this should probably be done during install/first run
  def set_create_event_notifier
    resource =  Runcible::Resources::EventNotifier
    url = Setting.foreman_url + "/api/repositories/events"
    type = resource::EventTypes::REPO_PUBLISH_COMPLETE
    notifs = resource.list()

    #only create a notifier if one doesn't exist with the correct url
    exists = notifs.select{|n| n['event_types'] == [type] && n['notifier_config']['url'] == url}
    resource.create(resource::NotifierTypes::REST_API, {:url=>url}, [type]) if exists.empty?
  end

  def del_pulp_repo
    repo.delete
  end

  def repo_options
    {
      :pulp_id       => pulp_id,
      :relative_path => relative_path,
      :content_type  => content_type,
      :protected     => :false,
    }
  end

  def repo
    @repo ||= Content::Pulp::RepositoryClone.new(repo_options)
  end
end
