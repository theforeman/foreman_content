module Content
  class AvailableContentView < ActiveRecord::Base
    belongs_to :environment
    belongs_to :operatingsystem
    belongs_to :content_view

    validates_presence_of :content_view_id, :environment_id

    #todo needs to validate that default can't be archived and vice-versa

  end
end