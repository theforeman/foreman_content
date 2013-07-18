require 'runcible'
require 'logging'

::Runcible::Base.config = {
  :url      => "https://katello-a.appliedlogic.ca",
  :api_path => "/pulp/api/v2/",
  :user     => "admin",
  :timeout      => 60,
  :open_timeout => 60,
  :oauth    => {:oauth_secret => "+7cs4WhVrTM7D+kgQv98Qbnt3wO096pB",
                :oauth_key    => "katello" },
  :logging  => {:logger     => ::Logging.logger['pulp_rest'],
                :exception  => true,
                :debug      => true }
}

require File.dirname(File.absolute_path(__FILE__)) + '/repository_commands'
