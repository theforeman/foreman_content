module Content
  class RepositoryClone
    include Content::Orchestration::Pulp

    attr_reader :pulp
    belongs_to :repository
    belongs_to :content_view

    delegate :feed, :to => :repository

    REPO_PREFIX = '/pulp/repos/'

    # Repositories filtered by operating system architecture and environment.
    # architecture_id is nil for noarch repositories.
    # todo: rewrite this scope
    scope :available_for_host, lambda { |host|
      joins(:repository_definition => {:operatingsystems => :operatingsystem_repositories}, :repository_definition =>  {:product => :environments}).
      where(:architecture_id => [nil, host.architecture_id],
            :content_operatingsystem_repositories => { :operatingsystem_id => host.operatingsystem_id},
            :content_environment_products => { :environment_id => host.environment_id }).
      uniq}
  end
end
