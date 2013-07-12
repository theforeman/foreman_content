class CreateRepositoriesRepositories < ActiveRecord::Migration
  def change
    create_table    :repositories_repositories do |t|
      t.string      :name
      t.integer     :major
      t.string      :minor
      t.string      :content_type, :default => "yum", :null => false
      t.string      :arch, :default => "noarch", :null => false
      t.boolean     :enabled, :default => true
      t.string      :relative_path, :null => false
      t.string      :feed
      t.boolean     :unprotected, :default => false, :null => false
      t.references  :repositories_product, :null => false
      t.string      :pulp_id # generated automatically
      t.string      :cp_label # generated automatically
      t.string      :content_id, :null => false #generated automatically
      t.references  :repositories_gpg_key
      t.timestamps
    end
  end
end
