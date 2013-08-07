class CreateContentContentViewProducts < ActiveRecord::Migration
  def change
    create_table :content_content_view_products do |t|
      t.references :content_view, :null =>false
      t.references :product, :null =>false
    end
    add_index(:content_content_view_products, [:product_id, :content_view_id],:name=>'content6_view_products_index', :unique=>true)
  end
end
