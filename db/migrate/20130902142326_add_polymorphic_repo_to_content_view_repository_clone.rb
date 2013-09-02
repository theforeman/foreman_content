class AddPolymorphicRepoToContentViewRepositoryClone < ActiveRecord::Migration
  def change
    add_column :content_content_view_repository_clones, :repository_type, :string
    Content::ContentViewRepositoryClone.reset_column_information
    Content::ContentViewRepositoryClone.update_all(:repository_type => 'Content::RepositoryClone')
    rename_column :content_content_view_repository_clones, :repository_clone_id, :repository_id
  end
end
