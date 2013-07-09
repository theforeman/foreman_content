class AddDefaultGpgKeyToProduct < ActiveRecord::Migration
  def change
    add_column :products, :gpg_key_id, :integer
  end
end
