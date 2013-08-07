module Content
  class ContentView < ActiveRecord::Base
    has_many :available_content_views, :dependent => :destroy
    has_many :hostgroup, :through => :available_content_views

    delegate :operatingsystem, :to => :available_content_views, :allow_nil => true
  end
end