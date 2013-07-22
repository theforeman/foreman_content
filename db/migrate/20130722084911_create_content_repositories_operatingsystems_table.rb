class CreateContentRepositoriesOperatingsystemsTable < ActiveRecord::Migration
  def change
    create_table :content_repositories_operatingsystems do |t|
      t.references :repository, :null =>false
      t.references :operatingsystem, :null =>false
    end
    add_index(:content_repositories_operatingsystems, [:repository_id, :operatingsystem_id],:name=>'repository_operatingsystem_index', :unique=>true)
  end
end
