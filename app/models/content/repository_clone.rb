module Content
  class RepositoryClone
    include Content::Remote::Pulp::Repository
    include ::Orchestration
    include Content::Orchestration::Pulp

    belongs_to :repository

    after_initialize do
      self.pulp_id = Foreman.uuid.gsub("-", '')
    end

    REPO_PREFIX = '/pulp/repos/'

    # Repositories filtered by operating system architecture and environment.
    # architecture_id is nil for noarch repositories.
    scope :available_for_host, lambda { |host|
      joins(:repository_definition => {:operatingsystems => :operatingsystem_repositories}, :repository_definition =>  {:product => :environments}).
      where(:architecture_id => [nil, host.architecture_id],
            :content_operatingsystem_repositories => { :operatingsystem_id => host.operatingsystem_id},
            :content_environment_products => { :environment_id => host.environment_id }).
      uniq}


    def full_path
      pulp_url = URI.parse(Setting.pulp_url)
      scheme   = (unprotected ? 'http' : 'https')
      port     = (pulp_url.port == 443 || pulp_url.port == 80 ? "" : ":#{pulp_url.port}")
      "#{scheme}://#{pulp_url.host}#{port}#{REPO_PREFIX}#{relative_path}"
    end
  end
end
