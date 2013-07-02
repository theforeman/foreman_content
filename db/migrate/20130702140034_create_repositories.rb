class CreateRepositories < ActiveRecord::Migration
  def up
    create_table :repositories do |t|
      t.string   :name
      t.string   :pulp_id, :null => false
      t.string   :content_type, :default => "yum", :null => false
      t.timestamps
    end
  end

  def down
    drop_table :repositories
  end
end
