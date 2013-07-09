class AddGpgColumnToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :gpg_key_id, :integer
  end
end
