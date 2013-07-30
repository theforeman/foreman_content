class CreateContentProductOperatingsystems < ActiveRecord::Migration
  def change
    create_table :content_product_operatingsystems do |t|
       t.references :operatingsystem, :null =>false
       t.references :product, :null =>false
    end
    add_index(:content_product_operatingsystems, [:operatingsystem_id, :product_id],:name=>'product_operatingsystems_index', :unique=>true)
  end
end
