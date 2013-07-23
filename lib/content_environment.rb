module ContentEnvironment
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      has_many :environment_products, :dependent => :destroy, :uniq=>true, :class_name => 'Content::EnvironmentProduct'
      has_many :products, :through => :environment_products, :class_name => 'Content::Product'
    end
  end

  module InstanceMethods
  end
end