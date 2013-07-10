class CreateRepositoriesGpgKeys < ActiveRecord::Migration
  def change
    create_table :repositories_gpg_keys do |t|
      t.string :name, :null => false
      t.text :content, :null => false
      t.timestamps
    end
    add_index(:repositories_gpg_keys, [:name], :unique=>true)
  end
end
