class CreateRepositoriesProducts < ActiveRecord::Migration
  def change
    create_table   :repositories_products do |t|
      t.string     :name
      t.text       :description
      t.references :repositories_provider
      t.timestamps
    end
  end
end
