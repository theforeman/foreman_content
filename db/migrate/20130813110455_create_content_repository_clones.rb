class CreateContentRepositoryClones < ActiveRecord::Migration
  def change
    create_table :content_repository_clones do |t|
      t.string :name
      t.string :description
      t.references :repository
      t.string :relative_path
      t.string :pulp_id
      t.string :status
      t.datetime :last_published

      t.timestamps
    end
    add_index :content_repository_clones, :repository_id
    add_index :content_repository_clones, :pulp_id, :unique => true
  end
end
