class CreateContentOwnerRepositories < ActiveRecord::Migration
  def change
    create_table :content_operatingsystem_repositories do |t|
      t.references :repository, :null =>false
      t.references :operatingsystem
      t.references :product
    end
    add_index(:content_operatingsystem_repositories, [:repository_id, :operatingsystem_id],:name=>'operatingsystem_repositories_index', :unique=>true)
    add_index(:content_product_repositories, [:repository_id, :product_id],:name=>'product_repositories_index', :unique=>true)
  end
end
