module ContentHost
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      has_many :host_products, :dependent => :destroy, :uniq=>true,:foreign_key => :host_id, :class_name => 'Content::HostProduct'
      has_many :products, :through => :host_products, :class_name => 'Content::Product'

      scoped_search :in=>:products, :on=>:name, :complete_value => true, :rename => :product
    end
  end

  module InstanceMethods
  end
end