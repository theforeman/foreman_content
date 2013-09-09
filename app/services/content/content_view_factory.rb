module Content
  class ContentViewFactory
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming

    attr_accessor :originator_type, :originator_id, :parent_cv, :product_cv, :os_cv, :source_repositories
    validates_presence_of :originator_type, :originator_id

    def initialize(attributes = {})
      attributes.each do |name, value|
        instance_variable_set("@#{name}", value) if respond_to?("#{name}".to_sym)
      end
    end

    def persisted?
      false
    end

    def content_view
      case originator_type
        when 'Hostgroup'
          create_composite_content_view
        else
          ContentView.new(:repository_ids_to_clone => originator.repositories, :originator => originator)
      end
    end

    def repositories
      originator.repositories
    end

    private

    def originator
     originator ||= case originator_type
                      when 'Content::Product'
                        Product.find(originator_id)
                      when 'Operatingsystem'
                        Operatingsystem.find(originator_id)
                      when 'Hostgroup'
                        Hostgroup.find(originator_id)
                      else
                        raise _('Unknown type')
                    end
    end

    # create a composite content view of a hostgroup (the hostgroup may have a list of products) and a parent
    # content view. The parent content view is one of the hostgroup parent content views.
    # A hostgroup may have number of content views representing different versions of that hostgroup content.
    def create_composite_content_view
      clone_ids = Content::RepositoryClone.for_content_views([product_cv, os_cv]).pluck('content_repository_clones.id')
      source_ids = Content::Repository.for_content_views([product_cv, os_cv]).pluck('content_repositories.id')
      ContentView.new(:originator => originator,
                      :repository_clone_ids => clone_ids,
                      :repository_source_ids => source_ids,
                      :parent_id => parent_cv)
    end


  end
end
