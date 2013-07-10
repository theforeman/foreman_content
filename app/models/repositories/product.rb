module Repositories
  class Product < ActiveRecord::Base
    include ::Taxonomix

    belongs_to :provider, :inverse_of => :products, :class_name => "Repositories::Provider"

    validates_with Validators::DescriptionFormat, :attributes => :description
    validates :name, :presence => true
    validates_with Validators::NameFormat, :attributes => :name
    scoped_search :on => :name
  end
end
