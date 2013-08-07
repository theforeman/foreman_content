class CreateContentContentViews < ActiveRecord::Migration
  def change
    create_table   :content_content_views do |t|
      t.string     :name
      t.string     :sha
      t.timestamps
    end
  end
end
