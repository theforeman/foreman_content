module ContentHostgroup
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      has_many :hostgroup_products, :dependent => :destroy, :uniq=>true, :class_name => 'Content::HostgroupProduct'
      has_many :products, :through => :hostgroup_products, :class_name => 'Content::Product'
      has_many :repositories, :through => :products, :class_name => 'Content::Repository'

      scoped_search :in=>:products, :on=>:name, :complete_value => true, :rename => :product
    end
  end

  module InstanceMethods
    def inherited_product_ids
      Content::HostgroupProduct.where(:hostgroup_id => hostgroup.ancestor_ids).pluck(:product_id)
    end
  end
end