module ContentHostgroup
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      has_many :hostgroup_products, :dependent => :destroy, :uniq=>true, :class_name => 'Content::HostgroupProduct'
      has_many :products, :through => :hostgroup_products, :class_name => 'Content::Product'
      accepts_nested_attributes_for :hostgroup_products, :allow_destroy => true, :reject_if => :all_blank

      scoped_search :in=>:products, :on=>:name, :complete_value => true, :rename => :product
    end
  end

  module InstanceMethods
  end
end