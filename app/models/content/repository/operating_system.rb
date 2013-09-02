module Content
  class Repository::OperatingSystem < Repository

    validates_presence_of :operatingsystem_id

    def self.model_name
      Repository.model_name
    end

    def entity_name
      operatingsystem.to_label
    end

    def description
      entity_name
    end
  end
end