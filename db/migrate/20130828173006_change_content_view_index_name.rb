class ChangeContentViewIndexName < ActiveRecord::Migration
  OLD_NAME = :index_content_content_views_on_originator_id_and_originator_type
  def up
    rename_index :content_content_views, OLD_NAME, :content_view_id_type_index if index_name_exists? :content_content_views, OLD_NAME, nil
  end

  def down
    rename_index :content_content_views, :content_view_id_type_index, OLD_NAME
  end
end
