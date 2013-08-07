module Content
  class Product < ActiveRecord::Base
    include ::Taxonomix

    has_many :repositories
    has_many :repository_clones, :through => :repositories
    has_many :content_views, :as => :originator

    has_many :hostgroup_products, :dependent => :destroy, :uniq=>true
    has_many :hostgroups, :through => :hostgroup_products

    has_many :host_products, :dependent => :destroy, :uniq=>true
    has_many :hosts, :through => :host_products

    before_destroy EnsureNotUsedBy.new(:hostgroups, :hosts, :repositories)

    scope :has_repos, joins(:repositories).uniq

    validates_with Validators::DescriptionFormat, :attributes => :description
    validates :name, :presence => true
    validates_with Validators::NameFormat, :attributes => :name
    scoped_search :on => :name
    scoped_search :in => :repositories, :on => :name, :rename => :repository, :complete_value => :true

    def sync
      self.repositories.map{ |repo| repo.sync }
    end
  end
end
