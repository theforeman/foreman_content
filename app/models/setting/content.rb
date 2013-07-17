class Setting::Content< ::Setting
  BLANK_ATTRS << "use_candlepin"
  BLANK_ATTRS << "candlepin_url"
  BLANK_ATTRS << "pulp_url"


  def self.load_defaults
    return unless ActiveRecord::Base.connection.table_exists?('settings')
    return unless super

    Setting.transaction do
      [
        self.set('use_candlepin', "Use Candlepin to manage subscriptions", false),
        self.set('candlepin_url', "Candlepin URL", "127.0.0.1:5672"),
        self.set('pulp_url', "Pulp URL", "127.0.0.1:5672")
      ].compact.each { |s| self.create s.update(:category => "Setting::Content")}
    end

    true

  end

end