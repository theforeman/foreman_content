module Content
  class ContentViewHost < ActiveRecord::Base
    belongs_to :host
    belongs_to :content_view

    validates_presence_of :content_view_id, :host_id
    validates_uniqueness_of :content_view_id, :scope => :host_id
  end
end
