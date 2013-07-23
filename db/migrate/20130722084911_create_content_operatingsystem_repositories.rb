class CreateContentOperatingsystemRepositories < ActiveRecord::Migration
  def change
    create_table :content_operatingsystem_repositories do |t|
      t.references :repository, :null =>false
      t.references :operatingsystem, :null =>false
    end
    add_index(:content_operatingsystem_repositories, [:repository_id, :operatingsystem_id],:name=>'operatingsystem_repositories_index', :unique=>true)
  end
end
