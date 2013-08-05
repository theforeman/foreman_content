module Content::OperatingsystemExtensions
  extend ActiveSupport::Concern

  included do
    has_many :operatingsystem_repositories, :dependent => :destroy, :uniq => true, :class_name => 'Content::OperatingsystemRepository'
    has_many :repositories, :through => :operatingsystem_repositories, :class_name => 'Content::Repository'
    has_many :product_operatingsystems, :dependent => :destroy, :uniq => true, :class_name => 'Content::ProductOperatingsystem'
    has_many :products, :through => :product_operatingsystems, :class_name => 'Content::Product'
    has_many :default_repositories, :through => :products, :source => :repositories, :class_name => 'Content::Repository'
  end

end