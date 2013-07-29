require 'content/orchestration/pulp'
# TODO: split into a custom and red hat repositories:
# as handling of repo creation/updates is different between them
module Content
  class Repository < ActiveRecord::Base
    include CustomRepositoryPaths
    include Content::Remote::Pulp::Repository
    include ::Orchestration
    include Content::Orchestration::Pulp

    YUM_TYPE       = 'yum'
    KICKSTART_TYPE = 'kickstart'
    FILE_TYPE      = 'iso'
    TYPES          = [YUM_TYPE, KICKSTART_TYPE, FILE_TYPE]

    REPO_PREFIX = '/pulp/repos/'

    belongs_to :product
    belongs_to :gpg_key
    belongs_to :architecture
    has_many :operatingsystem_repositories, :dependent => :destroy, :uniq => true
    has_many :operatingsystems, :through => :operatingsystem_repositories

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

    # architecture_id is nil for noarch repositories.
    scope :for_host, lambda { |host| includes({ :product => :environments }).
      where(:architecture_id => [nil, host.architecture_id], :content_environment_products => { :environment_id => host.environment_id }) }

    scope :kickstart, where(:content_type => KICKSTART_TYPE)
    scope :yum, where(:content_type => YUM_TYPE)

    def update_cache
      nil
    end

    def full_path
      pulp_url = URI.parse(Setting.pulp_url)
      scheme   = (unprotected ? 'http' : 'https')
      port     = (pulp_url.port == 443 || pulp_url.port == 80 ? "" : ":#{pulp_url.port}")
      "#{scheme}://#{pulp_url.host}#{port}#{REPO_PREFIX}#{relative_path}"
    end

    # The label is used as a repository label in a yum repo file.
    def to_label
      "#{product.name}-#{name}".parameterize
    end
  end
end
