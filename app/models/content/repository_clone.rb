module Content
  class RepositoryClone < RepositoryBase
    include Content::Orchestration::RepositoryClone

    belongs_to :repository
    belongs_to :content_view

    validate :repository, :presence => true #TODO same for content_view

    delegate :feed, :to => :repository

    after_initialize do
      self.pulp_id ||= Foreman.uuid.gsub("-", '')
      self.relative_path ||= custom_repo_path("acme_org", "library", product.name, name) + "_" + Foreman.uuid.gsub("-", '')
      @pulp = Content::Pulp::RepositoryClone.new(self.pulp_id)
    end

    def content_type; "yum"; end
  end
end
