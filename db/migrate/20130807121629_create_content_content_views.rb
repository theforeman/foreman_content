class CreateContentContentViews < ActiveRecord::Migration
  def change
    create_table   :content_content_views do |t|
      t.text       :name
      t.boolean    :archived
      t.text       :sha
      t.timestamps
    end
  end
end
