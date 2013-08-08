module Content
  class RepositoryClone
    include Content::Orchestration::Pulp

    attr_reader :pulp
    belongs_to :repository
    belongs_to :content_view

    delegate :feed, :to => :repository

    after_initialize do
      self.pulp_id ||= Foreman.uuid.gsub("-", '')
      self.relative_path ||= custom_repo_path("acme_org", "library", product.name, name) + "_" + Foreman.uuid.gsub("-", '')
      @pulp = Content::Pulp::Repository.new(self.pulp_id)
    end
  end
end
