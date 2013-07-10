class AddDefaultGpgKeyToProduct < ActiveRecord::Migration
  def change
    add_column :repositories_products, :repositories_gpg_key_id, :integer
  end
end
