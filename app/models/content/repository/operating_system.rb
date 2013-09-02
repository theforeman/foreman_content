module Content
  class Repository::OperatingSystem < Repository
    alias_method :operatingsystem, :originator

    def self.model_name
      Repository.model_name
    end

    def entity_name
      operatingsystem.to_label
    end

    def description
      entity_name
    end

    private

    def set_originator_type
      self.originator_type ||= 'Operatingsystem'
    end
  end
end