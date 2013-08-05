module Content::HostgroupExtensions
  extend ActiveSupport::Concern

  included do
    has_many :hostgroup_products, :dependent => :destroy, :uniq => true, :class_name => 'Content::HostgroupProduct'
    has_many :products, :through => :hostgroup_products, :class_name => 'Content::Product'

    scoped_search :in => :products, :on => :name, :complete_value => true, :rename => :product
  end

  def inherited_product_ids
    Content::HostgroupProduct.where(:hostgroup_id => hostgroup.ancestor_ids).pluck(:product_id)
  end

  def all_product_ids
    (inherited_product_ids + product_ids).uniq
  end
end
