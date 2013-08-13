class CreateContentContentViews < ActiveRecord::Migration
  def change
    create_table   :content_content_views do |t|
      t.string     :name
      t.string     :ancestry
      t.timestamps
    end
    add_index(:content_content_views, [:ancestry],:name=>'content_view_ancestry_index')
  end
end
