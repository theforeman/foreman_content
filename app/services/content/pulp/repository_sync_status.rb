class Content::Pulp::RepositorySyncStatus
  attr_reader :state, :progress, :finish_time, :start_time, :sync_times, :sync_metrics, :message, :task_id

  HISTORY_ERROR   = 'failed'
  HISTORY_SUCCESS = 'success'
  FINISHED        = 'finished'
  ERROR           = 'error'
  RUNNING         = 'running'
  WAITING         = 'waiting'
  CANCELED        = 'canceled'
  NOT_SYNCED      = 'not synchronized'

  def initialize(attrs)
    @state      = NOT_SYNCED
    @sync_times = @sync_metrics = {}

    attrs.each do |k, v|
      instance_variable_set("@#{k}", v) if respond_to?("#{k}".to_sym)
    end
  end

  def not_synced?
    state == NOT_SYNCED
  end

  def running?
    state == RUNNING
  end

end