require 'test_helper'

module Repositories
  class NameFormatValidatorModelForTest
    include ActiveModel::Validations
    attr_accessor :name
    def initialize(aname); @name = aname; end
    validates_with Repositories::Validators::NameFormat, :attributes => :name
  end

  class NameFormatValidatorTest < ActiveSupport::TestCase
    test "should enforce min length" do
      assert !NameFormatValidatorModelForTest.new("").valid?
    end

    test "should enforce max length" do
      assert !NameFormatValidatorModelForTest.new("t" * (Repositories::Validators::NameFormat::MAX_LENGTH + 1)).valid?
    end

    test "should be valid with allowed characters" do
      assert NameFormatValidatorModelForTest.new("abc123 _-").valid?
    end

    test "should be invalid with a trailing space" do
      assert !NameFormatValidatorModelForTest.new("abc ").valid?
    end
  end
end
