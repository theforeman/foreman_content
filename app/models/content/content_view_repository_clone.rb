class Content::ContentViewRepositoryClone < ActiveRecord::Base
  belongs_to :content_view
  belongs_to :repository_clone
  validate :content_view_id, :repository_clone_id, :presence => true
end
