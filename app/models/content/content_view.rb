module Content
  class ContentView < ActiveRecord::Base
    has_many :content_view_availabilities, :dependent => :destroy
    belongs_to :operatingsystem, :through => :content_view_availabilities
    has_many :hostgroups, :through => :content_view_availabilities

  end
end