module Content
  class ContentViewFactory
    include ActiveModel::Conversion
    extend  ActiveModel::Naming

    attr_accessor :type, :originator_id, :parent_cv, :product_cv, :os_cv
    # create a content view of a single product
    def self.create_product_content_view(product_id)
      product = Product.find_by_id(product_id)
      ContentView.new(:source_repositories => product.repositories, :originator => product)
    end

    # create a content view of an operating system
    def self.create_os_content_view(operatingsystem_id)
      os = Operatingsystem.find_by_id(operatingsystem_id)
      ContentView.new(:source_repositories => os.repositories, :originator => os)
    end

    # create a composite content view of a hostgroup (the hostgroup may have a list of products) and a parent
    # content view. The parent content view is one of the hostgroup parent content views.
    # A hostgroup may have number of content views representing different versions of that hostgroup content.
    def self.create_composite_content_view(options = {})
      factory   = new(options)
      hostgroup = Hostgroup.find_by_id(factory.originator_id)
      clone_ids = Content::RepositoryClone.for_content_views([factory.product_cv, factory.os_cv]).
        pluck(:id)
      ContentView.new(:source_repositories=> [], :originator => hostgroup,
                      :repository_clone_ids => clone_ids, :parent_id => factory.parent_cv)
    end

    def initialize(attributes = {})
      attributes.each do |name, value|
        instance_variable_set("@#{name}", value) if respond_to?("#{name}".to_sym)
      end
    end

    def persisted?
      false
    end
  end
end
