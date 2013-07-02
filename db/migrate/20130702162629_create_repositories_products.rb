class CreateRepositoriesProducts < ActiveRecord::Migration
  def change
    create_table   :repositories_products do |t|
      t.string     :name
      t.text       :description
      t.integer    :multiplier
      t.references :repositories_provider
      t.string     :label, :null => false
      t.timestamps
    end
  end
end
