class Content::Pulp::EventHandler
  attr_reader :type, :status
  delegate :name, :to => :repo
  delegate :logger, :to => :Rails

  def initialize(pulp_id, params)
    @pulp_id      = pulp_id
    @params        = params
    @type, @status = parse_type
    return nil unless repo
    log
    update_state
  end

  private
  attr_reader :pulp_id, :params

  def repo
    @repo ||= case type
              when 'sync'
                Content::Repository.where(:pulp_id => pulp_id).first
              when 'promote'
                Content::RepositoryClone.where(:pulp_id => pulp_id).first
              end
  end

  def log
    logger.info "Repository #{name} #{type} #{status}"
  end

  def parse_type
    # converts repo.sync.start to ['sync','start']
    params['event_type'].gsub(/^repo\./, '').split('.')
  end

  def update_state
    #nothing to do if we didnt finish a task
    return unless status == 'finish'

    case type
    when 'sync'
      repo.update_attribute(:last_sync, finished_at) if success?
    when 'promote'
      repo.update_attribute(:last_published, finished_at) if success?

    end
  end

  def success?
    result == 'success'
  end

  def result
    params['payload']['result']
  end

  def finished_at
    Time.parse(params['payload']['completed'])
  end

end
