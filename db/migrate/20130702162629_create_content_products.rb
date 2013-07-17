class CreateContentProducts < ActiveRecord::Migration
  def change
    create_table   :content_products do |t|
      t.string     :name
      t.text       :description
      t.integer    :provider_id, :null => false
      t.string     :cp_id, :null => false
      t.timestamps
    end
  end
end
