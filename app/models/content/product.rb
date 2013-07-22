# TODO: It's probably worth it to keep cp_id separate from the main id, at least we could use a random id/uuid then.
module Content
  class Product < ActiveRecord::Base
    include ::Taxonomix


    belongs_to :provider
    has_many :repositories
    has_many :environment_products, :dependent => :destroy, :uniq=>true
    has_many :environments, :through => :environment_products
    accepts_nested_attributes_for :environment_products, :allow_destroy => true, :reject_if => :all_blank
    accepts_nested_attributes_for :environments

    validates_with Validators::DescriptionFormat, :attributes => :description
    validates :name, :presence => true
    validates_with Validators::NameFormat, :attributes => :name
    scoped_search :on => :name

    before_create do
      self.cp_id = Foreman.uuid.gsub('-', '')
    end

    after_create { ActiveSupport::Notifications.instrument('content.product.create', :entity => self) }
    after_update { ActiveSupport::Notifications.instrument('content.product.update', :entity => self) }
    after_destroy { ActiveSupport::Notifications.instrument('content.product.destroy', :id => id) }
  end
end
