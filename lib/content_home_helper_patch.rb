module ContentHomeHelperPatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :setting_options, :content_link
    end
  end

  module InstanceMethods
    # Adds a content link to the More menu
    def setting_options_with_content_link
      choices = setting_options_without_content_link
      content_group =
          [[_('Providers'),    :"content/providers"],
           [_('Gpg keys'),     :"content/gpg_keys"],
           [_('Products'),     :"content/products"],
           [_('Repositories'), :"content/repositories"]
          ]
      choices.insert(3,[:divider],[:group, _("Content"), content_group])
    end
  end
end