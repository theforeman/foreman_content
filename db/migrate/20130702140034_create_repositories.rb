class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories_repositories do |t|
      t.string   :name
      t.string   :content_type, :default => "yum", :null => false
      t.timestamps
    end
  end
end
