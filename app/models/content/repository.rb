module Content
  class Repository < ActiveRecord::Base
    include Content::Orchestration::Pulp::Sync
    include Content::CustomRepositoryPaths

    YUM_TYPE       = 'yum'
    KICKSTART_TYPE = 'kickstart'
    FILE_TYPE      = 'iso'
    TYPES          = [YUM_TYPE, KICKSTART_TYPE, FILE_TYPE]

    belongs_to :gpg_key
    belongs_to :architecture
    has_many :repository_clones

    validates_presence_of :entity_id, :type # can't create this object, only child

    validates :name, :presence => true
    validates_uniqueness_of :name, :scope => [:type, :entity_id]
    validates_inclusion_of :content_type,
                           :in          => TYPES,
                           :allow_blank => false,
                           :message     => (_("Please select content type from one of the following: %s") % TYPES.join(', '))

    scoped_search :on => [:name, :enabled], :complete_value => :true
    scoped_search :in => :architecture, :on => :name, :rename => :architecture, :complete_value => :true
    scoped_search :in => :operatingsystems, :on => :name, :rename => :os, :complete_value => :true
    scoped_search :in => :product, :on => :name, :rename => :product, :complete_value => :true

    scope :kickstart, where(:content_type => KICKSTART_TYPE)
    scope :yum, where(:content_type => YUM_TYPE)

    # The label is used as a repository label in a yum repo file.
    def to_label
      origin = product || operatingsystem
      "#{origin.to_label}-#{name}".parameterize
    end

    def publish product_name
      repository_clones.create(
        :name => self.name + "_clone",
        :relative_path => custom_repo_path("acme_org", "library", product_name, name) + Foreman.uuid.gsub("-", '')
      )
    end
  end
end
