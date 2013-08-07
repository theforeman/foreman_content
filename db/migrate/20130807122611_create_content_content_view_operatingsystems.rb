class CreateContentContentViewOperatingsystems < ActiveRecord::Migration
  def change
    create_table :content_content_view_operatingsystems do |t|
      t.references :content_view, :null =>false
      t.references :operatingsystem, :null =>false
    end
    add_index(:content_content_view_operatingsystems, [:operatingsystem_id, :content_view_id],:name=>'content_view_operatingsystems_index', :unique=>true)
  end
end
