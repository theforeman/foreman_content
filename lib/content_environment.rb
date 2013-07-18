module ContentEnvironment
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      has_many :environment_products, :dependent => :destroy, :uniq=>true
      has_many :products, :through => :environment_products
    end
  end

  module InstanceMethods
  end
end