module Repositories
  class Provider < ActiveRecord::Base
    include ::Taxonomix
    TYPES = %w[ RedHat Custom ] #todo: add puppet environment and debian provider types

    has_many :products, :inverse_of => :provider

    validates_with Validators::NameFormat, :attributes => :name
    validates_with Validators::DescriptionFormat, :attributes => :description

    scoped_search :on => [:name, :description,:type], :complete_value => :true
  end
end
