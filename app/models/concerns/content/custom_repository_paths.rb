module Content
  module CustomRepositoryPaths
    extend ActiveSupport::Concern

    def full_path
      pulp_url = URI.parse(Setting.pulp_url)
      scheme   = (unprotected ? 'http' : 'https')
      port     = (pulp_url.port == 443 || pulp_url.port == 80 ? "" : ":#{pulp_url.port}")
      "#{scheme}://#{pulp_url.host}#{port}#{REPO_PREFIX}#{relative_path}"
    end

    def repo_path_from_content_path(environment, content_path)
      content_path = content_path.sub(/^\//, "")
      path_prefix  = [environment.organization.label, environment.label].join("/")
      "#{path_prefix}/#{content_path}"
    end

    # repo path for custom product repos (RH repo paths are derived from
    # content url)
    def custom_repo_path(org_label, environment_label, product_label, repo_label)
      prefix = [org_label, environment_label].map { |x| x.gsub(/[^-\w]/, "_") }.join("/")
      prefix + custom_content_path(product_label, repo_label)
    end

    def custom_content_path(product_label, repo_label)
      parts = []
      # We generate repo path only for custom product content. We add this
      # constant string to avoid collisions with RH content. RH content url
      # begins usually with something like "/content/dist/rhel/...".
      # There we prefix custom content/repo url with "/custom/..."
      parts << "custom"
      parts += [product_label, repo_label]
      "/" + parts.map { |x| x.gsub(/[^-\w]/, "_") }.join("/")
    end
  end
end
