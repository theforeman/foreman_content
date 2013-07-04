require 'rubygems'
require 'bundler/setup'

ENV["RAILS_ENV"] = "test"
require File.join("foreman_app/config/environment.rb")

require 'test/unit'
require 'repositories'
require 'rails/test_help'

Rails.backtrace_cleaner.remove_silencers!

class ActiveSupport::TestCase
  foreman_dir =  File.expand_path("../foreman_app", File.join(Dir.pwd, __FILE__))
  fixture_path=File.join(foreman_dir, "test/fixtures")
  fixtures :all

  set_fixture_class({ :hosts => Host::Base })
end

def set_session_user
  SETTINGS[:login] ? {:user => User.admin.id, :expires_at => 5.minutes.from_now} : {}
end