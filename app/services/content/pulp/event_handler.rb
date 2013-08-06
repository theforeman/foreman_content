class Content::Pulp::EventHandler
  attr_reader :type, :status
  delegate :name, :to => :repo
  delegate :logger, :to => :Rails

  def initialize(pulp_id, params)
    @repo          = Content::Repository.where(:pulp_id => pulp_id).first
    @params        = params
    @type, @status = parse_type
    log
  end

  private
  attr_reader :repo, :params

  def log
    logger.info "Repository #{name} #{type} #{status}"
  end

  def parse_type
    # converts repo.sync.start to ['sync','start']
    params['event_type'].gsub(/^repo\./, '').split('.')
  end

end