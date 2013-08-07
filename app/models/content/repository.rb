require 'content/orchestration/pulp'
# TODO: split into a custom and red hat repositories:
# as handling of repo creation/updates is different between them
module Content
  class Repository < ActiveRecord::Base
    include CustomRepositoryPaths

    YUM_TYPE       = 'yum'
    KICKSTART_TYPE = 'kickstart'
    FILE_TYPE      = 'iso'
    TYPES          = [YUM_TYPE, KICKSTART_TYPE, FILE_TYPE]

    belongs_to :product
    belongs_to :gpg_key
    belongs_to :architecture
    has_many :operatingsystem_repositories, :dependent => :destroy, :uniq => true
    has_many :operatingsystems, :through => :operatingsystem_repositories
    has_many :repository_clones

    validates :product, :presence => true
    validates :name, :presence => true
    validates_uniqueness_of :name, :scope => :product_id
    validates_inclusion_of :content_type,
                           :in          => TYPES,
                           :allow_blank => false,
                           :message     => (_("Please select content type from one of the following: %s") % TYPES.join(', '))

    scoped_search :on => [:name, :enabled], :complete_value => :true
    scoped_search :in => :architecture, :on => :name, :rename => :architecture, :complete_value => :true
    scoped_search :in => :operatingsystems, :on => :name, :rename => :os, :complete_value => :true
    scoped_search :in => :product, :on => :name, :rename => :product, :complete_value => :true

    scope :attached_to_host, lambda { |host|
      where(:product_id => host.all_product_ids).available_for_host(host)
    }

    scope :kickstart, where(:content_type => KICKSTART_TYPE)
    scope :yum, where(:content_type => YUM_TYPE)

    def update_cache
      nil
    end

    # The label is used as a repository label in a yum repo file.
    def to_label
      "#{product.name}-#{name}".parameterize
    end

    def create_repository
      repositories.create(
        :feed => feed,
        :relative_path => custom_repo_path("acme_org", "library", product.name, name) + Foreman.uuid.gsub("-", '')
      )
    end
  end
end
