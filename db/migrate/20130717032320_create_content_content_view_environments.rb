class CreateContentContentViewEnvironments < ActiveRecord::Migration
  def change
    create_table :content_content_view_environments do |t|
       t.references :environment, :null =>false
       t.references :content_view, :null =>false
    end
  end
end
