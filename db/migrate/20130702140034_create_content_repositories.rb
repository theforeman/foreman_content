class CreateContentRepositories < ActiveRecord::Migration
  def change
    create_table    :content_repositories do |t|
      t.string      :pulp_id
      t.string      :name, :null => false
      t.string      :description
      t.string      :content_type, :default => "yum", :null => false
      t.boolean     :enabled, :default => true
      t.string      :relative_path, :null => false
      t.string      :feed, :null => false
      t.boolean     :unprotected, :default => false
      t.references  :product
      t.references  :operatingsystem
      t.string      :pulp_id
      t.references  :gpg_key
      t.references  :architecture
      t.datetime    :last_sync
      t.timestamps
    end
    add_index :content_repositories, :pulp_id, :unique => true
  end
end
