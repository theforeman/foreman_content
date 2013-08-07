
module Content
  class ContentViewRepositoryClone < ActiveRecord::Base
    belongs_to :content_view
    belongs_to :repository_clone
    validates_presence_of :content_view_id, :repository_clone_id
    validates_uniqueness_of :content_view_id, :scope => :repository_clone_id
  end
end