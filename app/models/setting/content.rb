class Setting::Content< ::Setting
  BLANK_ATTRS << "use_pulp"
  BLANK_ATTRS << "pulp_url"

  def self.load_defaults
    return unless ActiveRecord::Base.connection.table_exists?('settings')
    return unless super

    Setting.transaction do
      [
        self.set('use_pulp', "Use Pulp to manage content", true),
        self.set('pulp_url', "Pulp URL", "127.0.0.1:5672")
      ].compact.each { |s| self.create s.update(:category => "Setting::Content")}
    end

    true

  end

end