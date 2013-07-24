require 'content/orchestration/pulp'
# TODO: split into a custom and red hat repositories:
# as handling of repo creation/updates is different between them
module Content
  class Repository < ActiveRecord::Base
    include CustomRepositoryPaths
    include ::Orchestration
    include Content::Orchestration::Pulp

    YUM_TYPE  = 'yum'
    FILE_TYPE = 'file'
    TYPES     = [YUM_TYPE, FILE_TYPE]

    belongs_to :product
    belongs_to :gpg_key
    belongs_to :architecture
    has_many :operatingsystem_repositories, :dependent => :destroy, :uniq=>true
    has_many :operatingsystems, :through => :operatingsystem_repositories

    validates :product, :presence => true
    validates :name, :presence => true
    # TODO: add relative_path validation (valid url format)

    validates_inclusion_of :content_type,
      :in          => TYPES,
      :allow_blank => false,
      :message     => (_("Please select content type from one of the following: %s") % TYPES.join(', '))

    scoped_search :on => [:name, :enabled], :complete_value => :true
    scoped_search :in => :architectures, :on => :name, :rename => :architecture, :complete_value => :true
    scoped_search :in => :operatingsystems, :on => :name, :rename => :os, :complete_value => :true

    def orchestration_errors?
      errors.empty?
    end

    def update_cache
      nil
    end

  end
end
