module ContentHost
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      has_many :host_products, :dependent => :destroy, :uniq=>true, :class_name => 'Content::HostProduct'
      has_many :products, :through => :host_products, :class_name => 'Content::Product'
      accepts_nested_attributes_for :host_products, :allow_destroy => true, :reject_if => :all_blank

      scoped_search :in=>:products, :on=>:name, :complete_value => true, :rename => :product
    end
  end

  module InstanceMethods
  end
end