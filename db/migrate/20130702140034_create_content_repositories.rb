class CreateContentRepositories < ActiveRecord::Migration
  def change
    create_table    :content_repositories do |t|
      t.string      :name, :null => false
      t.string      :content_type, :default => "yum", :null => false
      t.boolean     :enabled, :default => true
      t.string      :relative_path, :null => false
      t.string      :feed
      t.boolean     :unprotected, :default => false, :null => false
      t.integer     :product_id, :null => false
      t.string      :pulp_id, :null => false # generated automatically
      t.string      :cp_label # generated automatically
      t.string      :content_id, :null => false #generated automatically
      t.integer     :gpg_key_id
      t.references  :operatingsystem
      t.references  :architecture
      t.timestamps
    end
    add_index :content_repositories, :pulp_id, :unique => true
  end
end
