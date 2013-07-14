module RepositoriesTaxonomy
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      has_many :products, :through => :taxable_taxonomies, :source => :taxable, :source_type => 'Repositories::Product'
      alias_method_chain :dup, :repositories_dup
    end
  end

  module InstanceMethods
    def dup_with_repositories_dup
      new = dup_without_repositories_dup
      new.products = products
      new
    end
  end
end