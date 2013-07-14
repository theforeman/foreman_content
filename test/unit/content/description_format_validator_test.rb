require 'test_helper'

module Content
  class DescriptionFormatValidatorModelForTest
    include ActiveModel::Validations
    attr_accessor :desc
    def initialize(adescription); @desc = adescription; end
    validates_with Content::Validators::DescriptionFormat, :attributes => :desc
  end

  class DescriptionFormatValidatorTest < ActiveSupport::TestCase
    test "should enforce max length" do
      assert !DescriptionFormatValidatorModelForTest.new("t" * (Content::Validators::DescriptionFormat::MAX_LENGTH + 1)).valid?
    end

    test "should be valid with allowed number of characters" do
      assert DescriptionFormatValidatorModelForTest.new("a description").valid?
    end
  end
end
