# TODO: It's probably worth it to keep cp_id separate from the main id, at least we could use a random id/uuid then.
module Content
  class Product < ActiveRecord::Base
    include ::Taxonomix

    belongs_to :provider, :inverse_of => :products, :class_name => "Content::Provider"
    has_many :repositories, :inverse_of => :product, :class_name => "Content::Repository"

    validates_with Validators::DescriptionFormat, :attributes => :description
    validates :name, :presence => true
    validates_with Validators::NameFormat, :attributes => :name
    scoped_search :on => :name

    after_create { ActiveSupport::Notifications.instrument('content.product.create', :entity => self) }
    after_update { ActiveSupport::Notifications.instrument('content.product.update', :entity => self) }
    after_destroy { ActiveSupport::Notifications.instrument('content.product.destroy', :id => id) }
  end
end
