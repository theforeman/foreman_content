class CreateContentContentViewRepositoryClones < ActiveRecord::Migration
  def change
    create_table    :content_content_view_repository_clones do |t|
      t.references  :repository_clone
      t.references  :content_view
    end
    add_index(:content_content_view_repository_clones, [:repository_clone_id, :content_view_id],:name=>'content_view_repo_clone_index', :unique=>true)
  end
end
