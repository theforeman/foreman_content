module ContentHostsController
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      after_filter :verify_repository_status, :only => [:create]
    end
  end

  module InstanceMethods
    def verify_repository_status
      return if @host.new_record?
      repositories = ::Content::Repository.attached_to_host(@host)
      repositories.each do |r|
        flash[:warning] = "Repository '#{r.name}' is not ready to be used." unless r.sync_status.synced?
      end
    end
  end
end
