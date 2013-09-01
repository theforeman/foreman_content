class AddPublishBooleanToContentRepository < ActiveRecord::Migration
  def change
    add_column :content_repositories, :publish, :boolean
    add_index :content_repositories, :publish, :name => :content_repo_publish_index
  end
end
