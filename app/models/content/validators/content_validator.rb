module Content
  module Validators
    class ContentValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        begin
          value.encode("UTF-8", 'binary') if !value.blank? && value.respond_to?(:encode)
        rescue
          record.errors[attribute] << (options[:message] || _("cannot be a binary file."))
        end
      end
    end
  end
end