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

  def self.ensure_sync_notification
    include Rails.application.routes.url_helpers

    resource = Runcible::Resources::EventNotifier
    url      = events_repositories_url(:only_path => false, :host => Setting[:foreman_url])
    type     = '*' #resource::EventTypes::REPO_SYNC_COMPLETE
    notifs   = resource.list

    #delete any similar tasks with the wrong url (in case it changed)
    notifs.select { |n| n['event_types'] == [type] && n['notifier_config']['url'] != url }.each do |e|
      resource.delete(e['id'])
    end

    #only create a notifier if one doesn't exist with the correct url
    exists = notifs.select { |n| n['event_types'] == [type] && n['notifier_config']['url'] == url }
    resource.create(resource::NotifierTypes::REST_API, { :url => url }, [type]) if exists.empty?
  end

end
