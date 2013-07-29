class CreateContentRepositories < ActiveRecord::Migration
  def change
    create_table    :content_repositories do |t|
      t.string      :name, :null => false
      t.string      :description
      t.string      :content_type, :default => "yum", :null => false
      t.boolean     :enabled, :default => true
      t.string      :relative_path
      t.string      :feed
      t.boolean     :unprotected, :default => false
      t.references  :product, :null => false
      t.string      :pulp_id
      t.references  :gpg_key
      t.references  :architecture
      t.timestamps
    end
    add_index :content_repositories, :pulp_id, :unique => true
  end
end
