module ContentHost
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      has_many :host_products, :dependent => :destroy, :uniq=>true,:foreign_key => :host_id, :class_name => 'Content::HostProduct'
      has_many :products, :through => :host_products, :class_name => 'Content::Product'

      scoped_search :in=>:products, :on=>:name, :complete_value => true, :rename => :product

      alias_method_chain :params, :repositories
    end
  end

  module InstanceMethods

    # adds repository hash to ENC global parameters
    def params_with_repositories
      # convert all repos to a format that puppet create_resource with yumrepo can consume
      repos = Hash[attached_repositories.map{ |repo| [repo.name, format_repo(repo)] }]
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

    def attached_repositories
      Content::Repository.attached_to_host(self)
    end

    private

    # convert a repository to a format that puppet create_resource with yumrepo can consume
    def format_repo repo
       {
         'baseurl' => repo.full_path,
         # yum repos have descr field but no name, if descr is empty use the repo name
         'descr' => repo.description.blank? ? repo.name : repo.description,
         'enabled' => repo.enabled ? '1': '0',
         'gpgcheck' => !!repo.gpg_key ? '1': '0'
       }
     end

  end
end