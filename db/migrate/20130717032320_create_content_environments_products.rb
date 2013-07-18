class CreateContentEnvironmentsProducts < ActiveRecord::Migration
  def change
    create_table :content_environment_products do |t|
       t.references :environment, :null =>false
       t.references :product, :null =>false
    end
    add_index(:content_environment_products, [:environment_id, :product_id],:name=>'environment_products_index', :unique=>true)
  end
end
