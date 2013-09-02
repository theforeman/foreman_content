module Content
  class Repository::Product < Repository
    alias_method :product, :originator
    has_many :operatingsystem_repositories, :foreign_key => :repository_id, :dependent => :destroy, :uniq => true
    has_many :operatingsystems, :through => :operatingsystem_repositories
    delegate :description, :to => :product

    def self.model_name
      Repository.model_name
    end

    def content_types
      TYPES - [KICKSTART_TYPE]
    end

    def entity_name
      product.name
    end

    private

    def set_originator_type
      self.originator_type = 'Content::Product'
    end
  end
end