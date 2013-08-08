class CreateContentAvailableContentViews < ActiveRecord::Migration
  def change
    create_table :content_available_content_views do |t|
       t.references :environment, :null =>false
       t.references :content_view, :null =>false
       t.references :hostgroup
       t.references :operatingsystem
       t.boolean    :archived
       t.boolean    :default
    end
  end
end
