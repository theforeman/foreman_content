module Content
  class RepositoryClone < RepositoryBase
    include Content::Orchestration::RepositoryClone

    belongs_to :repository
    belongs_to :content_view

    validate :relative_path, :repository, :presence => true #TODO same for content_view

    delegate :feed, :to => :repository

    after_initialize do
      self.pulp_id ||= Foreman.uuid.gsub("-", '')
      @pulp = Content::Pulp::RepositoryClone.new(
        :pulp_id => self.pulp_id, :content_type => "yum", :relative_path => self.relative_path)
    end

    def content_type; "yum"; end
  end
end
