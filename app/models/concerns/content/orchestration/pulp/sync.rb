module Content::Orchestration::Pulp::Sync
  extend ActiveSupport::Concern
  include Content::Orchestration::Pulp

  included do
    after_validation :queue_pulp
    before_destroy :queue_pulp_destroy unless Rails.env.test?
    attr_accessor :interval, :hour, :minute, :schedule
    validates :interval, :inclusion => { :in => %w(D W) }, :if => :schedule_sync?
    validates :hour, :minute, :numericality => true, :if => :schedule_sync?
  end

  def last_sync
    read_attribute(:last_sync) || repo.last_sync
  end

  private

  def queue_pulp
    return unless pulp? and errors.empty?
    new_record? ? queue_pulp_create : queue_pulp_update
  end

  def queue_pulp_create
    logger.debug "Scheduling new Pulp Repository"
    queue.create(:name   => _("Create Pulp Repository for %s") % self, :priority => 10,
                 :action => [self, :set_pulp_repo])
    logger.debug "Scheduling new Pulp Repository Sync"
    queue.create(:name   => _("Sync Pulp Repository %s") % self, :priority => 20,
                 :action => [self, :set_sync_pulp_repo])
    if schedule_sync?
      logger.debug "Scheduling Pulp Repository sync scheduler"
      queue.create(:name   => _("Sync Schedule Pulp Repository %s") % self, :priority => 30,
                   :action => [self, :set_sync_schedule_pulp_repo])
    end
  end

  def queue_pulp_update
    # TODO: handle repo updates.
  end

  def queue_pulp_destroy
    return unless pulp? and errors.empty?
    logger.debug _("Scheduling removal of Pulp Repository %s") % name
    queue.create(:name   => _("Delete Pulp repository for %s") % name, :priority => 50,
                 :action => [self, :del_pulp_repo])
  end

  def set_pulp_repo
    publish ? repo.create_with_distributor : repo.create
  end

  def del_pulp_repo
    repo.delete
  end

  def set_sync_pulp_repo
    repo.sync
  end

  def del_sync_pulp_repo
    repo.cancel_running_sync!
  end

  def set_sync_schedule_pulp_repo
    repo.sync_schedule = sync_schedule_time
  end

  def del_sync_schedule_pulp_repo
    repo.sync_schedule = nil
  end

  def repo_options
    {
      :pulp_id       => pulp_repo_id,
      :name          => to_label,
      :description   => description,
      :feed          => feed,
      :content_type  => content_type,
      :protected     => unprotected,
      :relative_path => relative_path,
      :auto_publish  => publish
    }
  end

  def repo
    @repo ||= Content::Pulp::Repository.new(repo_options)
  end

  def relative_path
    to_label.parameterize
  end

  def schedule_sync?
    schedule.present?
  end

  def sync_schedule_time
    return if schedule.blank?
    time       = Time.parse("00:#{hour}:#{minute}").iso8601
    repetition = "R1" # no limit of hour many syncs
    "#{repetition}/#{time}/P1#{interval}"
  end

end