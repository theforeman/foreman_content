class CreateContentRepositories < ActiveRecord::Migration
  def change
    create_table    :content_repositories do |t|
      t.string      :type
      t.string      :pulp_id, :null => false
      t.string      :name, :null => false
      t.string      :description
      t.string      :content_type, :default => "yum", :null => false
      t.boolean     :enabled, :default => true
      t.string      :relative_path
      t.string      :feed
      t.boolean     :unprotected, :default => false
      t.string      :pulp_id
      t.references  :gpg_key
      t.references  :architecture
      t.string      :status
      t.datetime    :published # repository clone
      t.datetime    :last_sync # repository master
      t.references  :product # repository master
      t.references  :operatingsystem # repository master
      t.references  :repository # repository clone
      t.references  :content_view # repository clone
      t.timestamps
    end
    add_index :content_repositories, :pulp_id, :unique => true
  end
end
