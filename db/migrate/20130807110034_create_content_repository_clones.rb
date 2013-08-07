class CreateContentRepositoryClones < ActiveRecord::Migration
  def change
    create_table    :content_repository_clones do |t|
      t.references  :repository
      t.string      :feed, :null => false
      t.string      :relative_path, :null => false
      t.string      :pulp_id, :null => false
      t.string      :status
      t.datetime    :sync_date
      t.datetime    :published
      t.timestamps
    end
  end
end
