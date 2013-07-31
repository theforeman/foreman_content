module ContentHostsController
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      after_filter :verify_repository_status, :only => [:create, :setBuild, :cancelBuild]
    end
  end

  module InstanceMethods
    def verify_repository_status
      return if @host.new_record?
      @host.attached_repositories.each do |r|
        flash[:warning] = "Repository '#{r.name}' is not ready to be used." unless r.sync_status.synced?
      end
    end
  end
end
