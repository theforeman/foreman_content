module Content
  class Repository::OperatingSystem < Repository

    validates_presence_of :operatingsystem

    def self.model_name
      Repository.model_name
    end

    def entity_name
      operatingsystem.to_label
    end
  end
end