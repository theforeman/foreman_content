module Content
  class OperatingsystemRepository < Repository

    belongs_to :operatingsystem, :foreign_key => :entity_id

  end
end