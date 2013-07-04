require 'test_helper'

module Repositories
  class ProductValidationTest < ActiveSupport::TestCase
    test "valid provider should be valid" do
      assert Product.new(:name => "test", :description => "a description").valid?
    end

    test "should fail validation when the name is invalid" do
      assert !Product.new(:name => nil, :description => "a description").valid?
      assert !Provider.new(:name => "t" * (Validators::NameFormat::MAX_LENGTH + 1), :description => "a description").valid?
    end

    test "should fail validation when the description is invalid" do
      assert !Product.new(:name => "test", :description => "t" * (Validators::DescriptionFormat::MAX_LENGTH + 1)).valid?
    end
  end
end
