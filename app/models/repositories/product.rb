require 'repositories/amqp'

module Repositories
  class Product < ActiveRecord::Base
    include ::Taxonomix

    belongs_to :provider, :inverse_of => :products, :class_name => "Repositories::Provider"

    validates_with Validators::DescriptionFormat, :attributes => :description
    validates :name, :presence => true
    validates_with Validators::NameFormat, :attributes => :name
    scoped_search :on => :name

    after_create { ActiveSupport::Notifications.instrument('repositories.product.create', :entity => self) }
    after_update { ActiveSupport::Notifications.instrument('repositories.product.update', :entity => self) }
    after_destroy { ActiveSupport::Notifications.instrument('repositories.product.destroy', :id => id) }
  end
end
