module Content
  class OperatingsystemRepository < ActiveRecord::Base
    belongs_to :operatingsystem
    belongs_to :repository
    validates_presence_of :operatingsystem_id, :repository_id
    validates_uniqueness_of :operatingsystem_id, :scope => :repository_id
  end
end