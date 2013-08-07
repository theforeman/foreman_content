module Content
  class HostProduct < ActiveRecord::Base
    belongs_to :product
    belongs_to :host
    validates_presence_of :product_id, :host_id
    validates_uniqueness_of :product_id, :scope => :host_id

  end
end