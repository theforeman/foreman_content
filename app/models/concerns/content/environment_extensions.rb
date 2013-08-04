module Content::EnvironmentExtensions
  extend ActiveSupport::Concern

  included do
    has_many :environment_products, :dependent => :destroy, :uniq => true, :class_name => 'Content::EnvironmentProduct'
    has_many :products, :through => :environment_products, :class_name => 'Content::Product'
  end

end