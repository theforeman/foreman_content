class Setting::Content< ::Setting
  BLANK_ATTRS << "use_pulp"
  BLANK_ATTRS << "pulp_url"
  BLANK_ATTRS << "pulp_oauth_secret"
  BLANK_ATTRS << "pulp_oauth_key"

  def self.load_defaults
    return unless ActiveRecord::Base.connection.table_exists?('settings')
    return unless super

    Setting.transaction do
      [
        self.set('use_pulp', "Use Pulp to manage content", true),
        self.set('pulp_url', "Pulp URL", "https://127.0.0.1/pulp/api/v2/"),
        self.set('pulp_oauth_secret', "Pulp OAuth Secret", ""),
        self.set('pulp_oauth_key', "Pulp OAuth Key", ""),
      ].compact.each { |s| self.create s.update(:category => "Setting::Content") }
    end

    true

  end

end
