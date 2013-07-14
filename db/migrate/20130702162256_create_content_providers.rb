class CreateContentProviders < ActiveRecord::Migration
  def change
    create_table :content_providers do |t|
      t.string   :name
      t.text     :description
      t.string   :repository_url # 'RedHat' provider only
      t.string   :type
      t.timestamps
    end
  end
end
