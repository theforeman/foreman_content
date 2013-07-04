module Repositories
  class Provider < ActiveRecord::Base
    include ::Taxonomix

    has_many :products, :inverse_of => :provider
    validates :name, :presence => true

    validates_with Validators::NameFormat, :attributes => :name
    validates_with Validators::DescriptionFormat, :attributes => :description
  end
end
