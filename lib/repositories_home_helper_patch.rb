module RepositoriesHomeHelperPatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :setting_options, :repositories_link
    end
  end

  module InstanceMethods
    # Adds a discovers link to the More menu
    def setting_options_with_repositories_link
      choices = setting_options_without_repositories_link
      repositories_group =
          [[_('Providers'),     :"repositories/providers"],
           [_('Gpg keys'),     :"repositories/gpg_keys"],
           [_('Products'),      :"repositories/products"]
          #[_('Repositories'),  :"repositories/repositories"]
          ]
      choices.insert(3,[:divider],[:group, _("Repositories"), repositories_group])
    end
  end
end