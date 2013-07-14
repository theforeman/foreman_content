class CreateContentGpgKeys < ActiveRecord::Migration
  def change
    create_table :content_gpg_keys do |t|
      t.string :name, :null => false
      t.text :content, :null => false
      t.timestamps
    end
    add_index(:content_gpg_keys, [:name], :unique=>true)
  end
end
