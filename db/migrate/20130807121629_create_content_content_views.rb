class CreateContentContentViews < ActiveRecord::Migration
  def change
    create_table   :content_content_views do |t|
      t.string     :name
      t.string     :sha
      t.references :operatingsystem
      t.references :product
      t.timestamps
    end
    add_index(:content_content_views, [:product_id],:name=>'content_view_products_index')
    add_index(:content_content_views, [:operatingsystem_id],:name=>'content_view_operatingsystems_index')
  end
end
