class Content::ContentViewRepositoryClone < ActiveRecord::Base
  belongs_to :content_view
  belongs_to :repository, :polymorphic => true
  validate :content_view_id, :repository_id, :repository_type, :presence => true
end
