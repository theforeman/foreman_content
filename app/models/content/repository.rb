module Content
  class Repository < ActiveRecord::Base
    include Content::Orchestration::Pulp::Sync
    include Foreman::STI
    include Content::RepositoryCommon

    YUM_TYPE       = 'yum'
    KICKSTART_TYPE = 'kickstart'
    FILE_TYPE      = 'iso'
    TYPES          = [YUM_TYPE, KICKSTART_TYPE, FILE_TYPE]

    belongs_to :originator, :polymorphic => true
    belongs_to :gpg_key
    belongs_to :architecture
    has_many :repository_clones

    before_validation :set_originator_type
    before_destroy EnsureNotUsedBy.new(:repository_clones)

    validates_presence_of :type # can't create this object, only child

    validates_presence_of :originator_id, :originator_type

    validates :name, :presence => true
    validates_uniqueness_of :name, :scope => [:originator_type]
    validates :feed, :presence => true, :uniqueness => true
    validates_inclusion_of :content_type,
                           :in          => TYPES,
                           :allow_blank => false,
                           :message     => (_("Please select content type from one of the following: %s") % TYPES.join(', '))

    scoped_search :on => [:name, :enabled], :complete_value => :true
    scoped_search :in => :architecture, :on => :name, :rename => :architecture, :complete_value => :true
    belongs_to :search_operatingsystems, :class_name => 'Operatingsystem', :foreign_key => :originator_id,
               :conditions => '"content_repositories"."originator_type" = "Operatingsystem"'
    belongs_to :search_products, :class_name => 'Content::Product', :foreign_key => :originator_id,
               :conditions => '"content_repositories"."originator_type" = "Content::Product"'
    scoped_search :in => :search_products, :on => :name, :rename => :product,
                  :complete_value => :true, :only_explicit => true
    scoped_search :in => :search_operatingsystems, :on => :name, :rename => :operatingsystem,
                  :complete_value => :true, :only_explicit => true

    scope :kickstart, where(:content_type => KICKSTART_TYPE)
    scope :yum, where(:content_type => YUM_TYPE)

    def content_types
      TYPES
    end

    # The label is used as a repository label in a yum repo file.
    def to_label
      "#{entity_name}-#{name}".parameterize
    end

    #inhariters are expected to override this method
    def entity_name
      ''
    end

    def clone content_view
      repository_clones.create!(
        :content_views => [content_view],
        :name => self.name + "_clone",
        :relative_path => "content_views/#{to_label}/#{Foreman.uuid}"
      )
    end

  end
end
