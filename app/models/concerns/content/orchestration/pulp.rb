module Content::Orchestration::Pulp
  extend ActiveSupport::Concern
  include ::Orchestration

  included do
    delegate :sync_status, :sync, :counters, :sync_history, :state, :to => :repo
  end

  def orchestration_errors?
    errors.empty?
  end

  def pulp?
    @use_pulp ||= Setting.use_pulp
  end

  def update_cache; nil; end
  def progress_report_id
    @progress_report_id ||= Foreman.uuid
  end

  def pulp_repo_id
   self.pulp_id ||= Foreman.uuid.gsub("-", '')
  end
end