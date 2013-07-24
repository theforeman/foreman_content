# TODO: It's probably worth it to keep cp_id separate from the main id, at least we could use a random id/uuid then.
module Content
  class Product < ActiveRecord::Base
    include ::Taxonomix

    belongs_to :provider
    has_many :repositories
    has_many :environment_products, :dependent => :destroy, :uniq=>true
    has_many :environments, :through => :environment_products

    has_many :hostgroup_products, :dependent => :destroy, :uniq=>true
    has_many :hostgroups, :through => :hostgroup_products

    has_many :host_products, :dependent => :destroy, :uniq=>true
    has_many :hosts, :through => :host_products

    validates_with Validators::DescriptionFormat, :attributes => :description
    validates :name, :presence => true
    validates_with Validators::NameFormat, :attributes => :name
    scoped_search :on => :name

    before_create do
      self.cp_id = Foreman.uuid.gsub('-', '')
    end

  end
end
