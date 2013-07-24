module ContentOperatingsystem
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      has_many :operatingsystem_repositories, :dependent => :destroy, :uniq=>true, :class_name => 'Content::OperatingsystemRepository'
      has_many :repositories, :through => :operatingsystem_repositories, :class_name => 'Content::Repository'
    end
  end

  module InstanceMethods
    def medium_uri host
      self.repositories.for_host(host).first.try(:full_path) || super
    end
  end
end