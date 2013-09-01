module Content::RepositoryCommon

  extend ActiveSupport::Concern

  REPO_PREFIX = '/pulp/repos/'

  def full_path
    pulp_url = URI.parse(Setting.pulp_url)
    scheme   = (unprotected ? 'http' : 'https')
    port     = (pulp_url.port == 443 || pulp_url.port == 80 ? "" : ":#{pulp_url.port}")
    "#{scheme}://#{pulp_url.host}#{port}#{REPO_PREFIX}#{relative_path}"
  end
end
