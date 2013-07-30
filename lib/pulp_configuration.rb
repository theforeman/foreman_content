require 'runcible'

class PulpConfiguration
  def self.initialize_runcible
    Runcible::Base.config = runcible_config
  end

  def self.runcible_config
    pulp_url = URI(Setting.pulp_url)
    {
      :url          => "#{pulp_url.scheme}://#{pulp_url.host}:#{pulp_url.port}",
      :api_path     => pulp_url.path,
      :user         => "admin",
      :timeout      => 60,
      :open_timeout => 60,
      :oauth        => { :oauth_secret => Setting['pulp_oauth_secret'],
                         :oauth_key    => Setting['pulp_oauth_key'] },
      :logging      => { :logger    => Rails.logger,
                         :exception => true,
                         :debug     => true }
    }
  end
end
