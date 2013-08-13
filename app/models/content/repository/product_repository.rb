module Content
  class ProductRepository < Repository

    belongs_to :product, :foreign_key => :entity_id
    has_many :operatingsystem_repositories, :dependent => :destroy, :uniq => true
    has_many :operatingsystems, :through => :operatingsystem_repositories

  end
end