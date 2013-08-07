class CreateContentContentViewRepositoryClones < ActiveRecord::Migration
  def change
    create_table :content_content_view_repository_clones do |t|
      t.references :content_view
      t.references :repository_clone

      t.timestamps
    end
    add_index :content_content_view_repository_clones, :content_view_id, :name => 'cv_repo_clone_cv_id'
    add_index :content_content_view_repository_clones, :repository_clone_id, :name => 'cv_repo_clone_clone_id'
  end
end
