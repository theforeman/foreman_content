module Content::HostgroupExtensions
  extend ActiveSupport::Concern

  included do
    has_many :hostgroup_products, :dependent => :destroy, :uniq => true, :class_name => 'Content::HostgroupProduct'
    has_many :products, :through => :hostgroup_products, :class_name => 'Content::Product'
    has_many :content_views, :as => :originator, :class_name => 'Content::ContentView'

    scope :has_content_views, joins(:content_views)

    scoped_search :in => :products, :on => :name, :complete_value => true, :rename => :product
    scoped_search :in => :content_views, :on => :name, :complete_value => true, :rename => :content_view
  end

  def inherited_product_ids
    return [] if hostgroup.ancestor_ids.empty?
    Content::HostgroupProduct.where(:hostgroup_id => hostgroup.ancestor_ids).pluck(:product_id)
  end

  def all_product_ids
    (inherited_product_ids + product_ids).uniq
  end

  def inherited_content_view_ids
    return [] if hostgroup.ancestor_ids.empty?
    Content::ContentView.where(:originator_id => hostgroup.ancestor_ids, :originator_type => 'Hostgroup').pluck(:id)
  end

  def all_content_views_ids
    (inherited_content_view_ids + content_view_ids).uniq
  end
end
