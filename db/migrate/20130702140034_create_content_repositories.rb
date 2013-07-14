class CreateContentRepositories < ActiveRecord::Migration
  def change
    create_table    :content_repositories do |t|
      t.string      :name
      t.string      :content_type, :default => "yum", :null => false
      t.boolean     :enabled, :default => true
      t.string      :relative_path, :null => false
      t.string      :feed
      t.boolean     :unprotected, :default => false, :null => false
      t.references  :content_product, :null => false
      t.string      :pulp_id # generated automatically
      t.string      :cp_label # generated automatically
      t.string      :content_id, :null => false #generated automatically
      t.references  :content_gpg_key
      t.references  :operatingsystem
      t.references  :architecture
      t.timestamps
    end
  end
end
