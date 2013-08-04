module Content::TaxonomyExtensions
  extend ActiveSupport::Concern

  included do
    has_many :products, :through => :taxable_taxonomies, :source => :taxable, :source_type => 'Content::Product'
    alias_method_chain :dup, :content_dup
  end

  def dup_with_content_dup
    new          = dup_without_content_dup
    new.products = products
    new
  end
end