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
    belongs_to :operatingsystem, :class_name => 'Redhat'

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

    # TODO: move this initialization into pulp- and candlepin-specific modules
    before_create do
      self.content_id = Foreman.uuid.gsub("-", '')
      self.cp_label   = name
    end

    def orchestration_errors?
      errors.empty?
    end

    def update_cache
      nil
    end

  end
end
