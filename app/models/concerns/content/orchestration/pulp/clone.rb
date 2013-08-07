module Content::Orchestration::Pulp::Clone
  extend ActiveSupport::Concern
  include Content::Orchestration::Pulp

  included do
    after_validation :repository_clone_save unless Rails.env.test?
    before_destroy :repository_clone_destroy unless Rails.env.test?
  end

  def last_published
    read_attribute(:last_published) || repo.last_publish
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
    repo.create_with_distributor
  end

  def set_copy_pulp_repo
    repo.copy_from(repository.pulp_id)
  end

  def set_publish_pulp_repo
    repo.publish
  end

  def set_create_event_notifier
    repo.create_event_notifier
  end

  def del_create_event_notifier; end

  def del_copy_pulp_repo; end

  def del_pulp_repo
    repo.delete
  end

  def repo_options
    {
      :pulp_id       => pulp_repo_id,
      :name          => "#{to_label}_clone",
      :relative_path => relative_path,
      :content_type  => content_type,
      :protected     => false,
    }
  end

  def repo
    @repo ||= Content::Pulp::RepositoryClone.new(repo_options)
  end
end
