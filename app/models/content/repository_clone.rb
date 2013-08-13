module Content
  class RepositoryClone < ActiveRecord::Base
    include Content::Orchestration::Pulp::Clone

    belongs_to :repository
    belongs_to :content_view
    attr_accessible :description, :last_published, :name, :pulp_id, :relative_path, :status

    validate :relative_path, :repository_id, :content_view_id, :presence => true

    delegate :content_type, :architecture, :unprotected, :gpg_key, :product,  :to => :repository
  end
end
