module Content
  class RepositoryClone < ActiveRecord::Base
    include Content::Orchestration::Pulp::Clone
    include Content::RepositoryCommon

    belongs_to :repository
    has_many :content_view_repository_clones, :dependent => :destroy
    has_many :content_views, :through => :content_view_repository_clones
    before_destroy EnsureNotUsedBy.new(:content_views)

    attr_accessible :description, :last_published, :name, :pulp_id, :relative_path, :status, :content_views
    validate :relative_path, :repository_id, :presence => true

    delegate :content_type, :architecture, :unprotected, :gpg_key, :product, :enabled, :to => :repository

    scope :for_content_views, lambda { |ids|
      joins(:content_view_repository_clones).
        where('content_content_view_repository_clones' => {:content_view_id => ids})
    }

  end
end
