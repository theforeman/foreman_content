module Content
  class Repository::Product < Repository

    has_many :operatingsystem_repositories, :foreign_key => :repository_id, :dependent => :destroy, :uniq => true
    has_many :operatingsystems, :through => :operatingsystem_repositories

    validates_presence_of :product

    def self.model_name
      Repository.model_name
    end

    def content_types
      TYPES - [KICKSTART_TYPE]
    end

    def entity_name
      product.name
    end
  end
end