class CreateContentProducts < ActiveRecord::Migration
  def change
    create_table   :content_products do |t|
      t.string     :name
      t.text       :description
      t.references :provider, :null => false
      t.string     :cp_id, :null => false
      t.references :gpg_key
      t.timestamps
    end
  end
end
