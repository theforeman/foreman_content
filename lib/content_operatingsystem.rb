module ContentOperatingsystem
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      has_many :operatingsystem_repositories, :dependent => :destroy, :uniq=>true
      has_many :repositories, :through => :operatingsystem_repositories
    end
  end

  module InstanceMethods
  end
end