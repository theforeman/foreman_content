module Content::HostExtensions
  extend ActiveSupport::Concern

  included do
    has_many :host_products, :dependent => :destroy, :uniq => true, :foreign_key => :host_id, :class_name => 'Content::HostProduct'
    has_many :products, :through => :host_products, :class_name => 'Content::Product'

    has_many :content_view_hosts, :dependent => :destroy, :uniq => true, :foreign_key => :host_id, :class_name => 'Content::ContentViewHost'
    has_many :content_views, :through => :content_view_hosts, :class_name => 'Content::ContentView'

    scoped_search :in => :products, :on => :name, :complete_value => true, :rename => :product

    alias_method_chain :params, :repositories
  end

  # adds repository hash to ENC global parameters
  def params_with_repositories
    # convert all repos to a format that puppet create_resource with yumrepo can consume
    repos = Hash[attached_repositories.map { |repo| [repo.to_label, format_repo(repo)] }]
    # adds a global parameter called repositories contain all repos
    params_without_repositories.merge('repositories' => repos)
  end

  # product_ids from the os default and hostgroup.
  def inherited_product_ids
    products = []
    products += operatingsystem.product_ids if operatingsystem
    products += Content::HostgroupProduct.where(:hostgroup_id => hostgroup.path_ids).pluck(:product_id) if hostgroup_id
    products.uniq
  end

  def all_product_ids
    (inherited_product_ids + product_ids).uniq
  end

  def inherited_content_view_ids
    return [] if hostgroup_id.nil? or environment_id.nil?

    Content::ContentView.joins(:available_content_views).
      where(:content_available_content_views => {:environment_id => environment_id}).
      where(:originator_type => 'Hostgroup', :originator_id => hostgroup_id).pluck(:id)
  end

  def all_content_view_ids
    (inherited_content_view_ids + content_view_ids).uniq
  end

  def attached_repositories
    return [] if all_content_view_ids.empty?
    Content::RepositoryClone.for_content_views(all_content_view_ids)
  end

  private

  # convert a repository to a format that puppet create_resource with yumrepo can consume
  def format_repo repo
    {
      'baseurl'  => repo.full_path,
      # yum repos have descr field but no name, if descr is empty use the repo name
      'descr'    => repo.description.blank? ? repo.name : repo.description,
      'enabled'  => repo.enabled ? '1' : '0',
      'gpgcheck' => !!repo.gpg_key ? '1' : '0'
    }
  end

end
