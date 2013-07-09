class CreateGpgs < ActiveRecord::Migration
  def change
    create_table :gpg_keys do |t|
      t.string :name, :null => false
      t.text :content, :null => false
      t.timestamps
    end
    add_index(:gpg_keys, [:name], :unique=>true)
  end
end
