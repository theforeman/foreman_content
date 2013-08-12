module Content
  class ContentView < ActiveRecord::Base
    has_many :available_content_views, :dependent => :destroy
    has_many :hostgroup, :through => :available_content_views
    delegate :operatingsystems, :to => :available_content_views, :allow_nil => true

    belongs_to :product
    belongs_to :operatingsystem

    before_save :clone_repos

    scoped_search :on => [:name, :created_at], :complete_value => :true
    scoped_search :in => :product, :on => :name, :rename => :product, :complete_value => :true
    scoped_search :in => :operatingsystem, :on => :name, :rename => :os, :complete_value => :true


    def to_label
      origin = product || operatingsystem
      name || "#{origin.to_label}-#{DateTime.now}"
    end

    def clone_repos
      origin = product || operatingsystem
      origin.repositories.each do |repository|
        repository.publish origin.name
      end
    end
  end
end