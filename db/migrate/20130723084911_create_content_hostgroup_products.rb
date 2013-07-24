class CreateContentHostgroupProducts < ActiveRecord::Migration
  def change
    create_table :content_hostgroup_products do |t|
      t.references :hostgroup, :null =>false
      t.references :product, :null =>false
    end
    add_index(:content_hostgroup_products, [:product_id, :hostgroup_id],:name=>'hostgroup_products_index', :unique=>true)
  end
end
