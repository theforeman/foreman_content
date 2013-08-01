module Content
  class Product < ActiveRecord::Base
    include ::Taxonomix

    has_many :repositories
    has_many :environment_products, :dependent => :destroy, :uniq=>true
    has_many :environments, :through => :environment_products

    has_many :product_operatingsystems, :dependent => :destroy, :uniq=>true
    has_many :operatingsystems, :through => :product_operatingsystems

    has_many :hostgroup_products, :dependent => :destroy, :uniq=>true
    has_many :hostgroups, :through => :hostgroup_products

    has_many :host_products, :dependent => :destroy, :uniq=>true
    has_many :hosts, :through => :host_products

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
