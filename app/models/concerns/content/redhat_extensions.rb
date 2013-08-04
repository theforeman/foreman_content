module Content::RedhatExtensions
  extend ActiveSupport::Concern

  included do
    alias_method_chain :medium_uri, :content_uri
  end

  def medium_uri_with_content_uri host, url = nil
    if url.nil? && (full_path = Content::Repository.available_for_host(host).kickstart.first.try(:full_path))
      URI.parse(full_path)
    else
      medium_uri_without_content_uri(host, url)
    end
  end

  # return an array of repositories for kickstart script as additional repos
  # to the kickstart main repo, this list will typically include updates and epel
  def repos host
    host.attached_repositories.yum.map { |repo| format_repo(repo) }
  end

  private
  # convert a repository to a format that kickstart script can consume
  def format_repo repo
    {
      :baseurl     => repo.full_path,
      :name        => repo.to_label,
      :description => repo.product.description,
      :enabled     => repo.enabled,
      :gpgcheck    => !!repo.gpg_key
    }
  end
end