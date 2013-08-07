module Content
  module Validators
    class DescriptionFormat < ActiveModel::EachValidator
      MAX_LENGTH = 1000
      def validate_each(record, attribute, value)
        if value
          record.errors[attribute] << N_("cannot contain more than %s characters") % MAX_LENGTH unless value.length <= MAX_LENGTH
        end
      end
    end
  end
end
