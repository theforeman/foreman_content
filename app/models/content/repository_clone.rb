module Content
  class RepositoryClone < ActiveRecord::Base
    include Content::Orchestration::Pulp::Clone

    REPO_PREFIX = '/pulp/repos/'

    belongs_to :repository
    has_many :content_view_repository_clones, :dependent => :destroy
    has_many :content_views, :through => :content_view_repository_clones
    before_destroy EnsureNotUsedBy.new(:content_views)

    attr_accessible :description, :last_published, :name, :pulp_id, :relative_path, :status, :content_views
    validate :relative_path, :repository_id, :presence => true

    delegate :content_type, :architecture, :unprotected, :gpg_key, :product, :to => :repository

    scope :for_content_views, lambda { |ids|
      joins(:content_view_repository_clones).
        where('content_content_view_repository_clones' => {:content_view_id => ids})
    }

    def full_path
      pulp_url = URI.parse(Setting.pulp_url)
      scheme   = (unprotected ? 'http' : 'https')
      port     = (pulp_url.port == 443 || pulp_url.port == 80 ? "" : ":#{pulp_url.port}")
      "#{scheme}://#{pulp_url.host}#{port}#{REPO_PREFIX}#{relative_path}"
    end
  end
end
