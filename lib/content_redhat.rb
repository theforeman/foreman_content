module ContentRedhat
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :medium_uri, :content_uri
    end
  end

  module InstanceMethods
    def medium_uri_with_content_uri host
      full_path = self.repositories.for_host(host).kickstart.first.try(:full_path)
      full_path ? URI.parse(full_path) : medium_uri_without_content_uri(host)
    end

    def repos host
      self.repositories.for_host(host).yum.map{|repo| repo_to_hash(repo)}
    end

    #
    def repo_to_hash repo
      {
        :baseurl => repo.full_path,
        :name => repo.product.name,
        :description => repo.product.description,
        :enabled => repo.enabled,
        :gpgcheck => !!repo.gpg_key
      }
    end
  end
end