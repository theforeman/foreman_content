class CreateContentProducts < ActiveRecord::Migration
  def change
    create_table   :content_products do |t|
      t.string     :name
      t.text       :description
      t.references :content_provider
      t.timestamps
    end
  end
end
