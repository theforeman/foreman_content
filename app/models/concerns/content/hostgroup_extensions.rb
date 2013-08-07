module Content::HostgroupExtensions
  extend ActiveSupport::Concern

  included do
    has_many :hostgroup_products, :dependent => :destroy, :uniq => true, :class_name => 'Content::HostgroupProduct'
    has_many :products, :through => :hostgroup_products, :class_name => 'Content::Product'

    has_many :available_content_veiws, :dependent => :destroy, :class_name => 'Content::AvailableContentView'
    has_many :content_views, :through => :available_content_veiws, :class_name => 'Content::ContentView'

    scoped_search :in => :products, :on => :name, :complete_value => true, :rename => :product
  end

  def inherited_product_ids
    Content::HostgroupProduct.where(:hostgroup_id => hostgroup.ancestor_ids).pluck(:product_id)
  end

  def all_product_ids
    (inherited_product_ids + product_ids).uniq
  end
end
