class CreateContentRepositoryClones < ActiveRecord::Migration
  def change
    create_table    :content_repository_clones do |t|
      t.references  :repository
      t.string      :relative_path
      t.datetime    :last_sync
      t.datetime    :published
      t.string      :pulp_id
      t.timestamps
    end
  end
end
