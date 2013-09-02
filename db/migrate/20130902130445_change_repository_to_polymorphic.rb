class ChangeRepositoryToPolymorphic < ActiveRecord::Migration
  def up
    add_column :content_repositories, :originator_type, :string
    add_column :content_repositories, :originator_id, :integer
    Content::Repository.reset_column_information

    Content::Repository.all.each do |repo|
      if repo.operatingsystem_id
        repo.originator_type = 'Operatingsystem'
        repo.originator_id   = repo.operatingsystem_id
      elsif repo.product_id
        repo.originator_type = 'Content::Product'
        repo.originator_id   = repo.product_id
      else
        raise "invalid repo type, can't continue: #{repo.inspect}"
      end
      repo.save(:validate => false)
    end
    remove_column :content_repositories, :operatingsystem_id
    remove_column :content_repositories, :product_id
  end

  def down
    add_column :content_repositories, :product_id, :integer
    add_column :content_repositories, :operatingsystem_id, :integer
    Content::Repository.reset_column_information

    Content::Repository.all.each do |repo|
      if repo.originator_type && repo.originator_id
        case repo.originator_type
          when 'Operatingsystem'
            repo.operatingsystem_id = repo.originator_id
          when 'Content::Product'
            repo.product_id = repo.originator_id
        end
        repo.save(:validate => false)
      end
    end
    remove_column :content_repositories, :originator_type
    remove_column :content_repositories, :originator_id
  end
end
