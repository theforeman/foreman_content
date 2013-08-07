class CreateContentContentViewAvailabilities < ActiveRecord::Migration
  def change
    create_table :content_content_view_availabilities do |t|
       t.references :environment, :null =>false
       t.references :content_view, :null =>false
       t.references :hostgroup
       t.references :operatingsystem
       t.boolean    :archived
       t.boolean    :default
    end
  end
end
