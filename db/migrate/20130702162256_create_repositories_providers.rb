class CreateRepositoriesProviders < ActiveRecord::Migration
  def change
    create_table :repositories_providers do |t|
      t.string   :name
      t.text     :description
      t.string   :repository_url # 'RedHat' provider only
      t.string   :type
      t.timestamps
    end
  end
end
