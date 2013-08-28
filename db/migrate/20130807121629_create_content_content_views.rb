class CreateContentContentViews < ActiveRecord::Migration
  def change
    create_table   :content_content_views do |t|
      t.string     :name
      t.string     :ancestry
      t.integer    :originator_id
      t.string     :originator_type

      t.timestamps
    end
    add_index(:content_content_views, :ancestry,:name=>'content_view_ancestry_index')
    add_index :content_content_views, [:originator_id, :originator_type], :name => 'content_view_id_type_index'
    add_index :content_content_views, :originator_type
  end
end
