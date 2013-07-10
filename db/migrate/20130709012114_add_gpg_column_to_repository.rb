class AddGpgColumnToRepository < ActiveRecord::Migration
  def change
    add_column :repositories_repositories, :repositories_gpg_key_id, :integer
  end
end
