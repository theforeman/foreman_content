class CreateContentHostProducts < ActiveRecord::Migration
  def change
    create_table :content_host_products do |t|
      t.references :host, :null =>false
      t.references :product, :null =>false
    end
    add_index(:content_host_products, [:product_id, :host_id],:name=>'host_products_index', :unique=>true)
  end
end
