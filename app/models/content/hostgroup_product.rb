module Content
  class HostgroupProduct < ActiveRecord::Base
    belongs_to :product
    belongs_to :hostgroup
    validates_presence_of :product_id, :hostgroup_id
    validates_uniqueness_of :product_id, :scope => :hostgroup_id
  end
end