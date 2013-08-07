module Content::HomeHelper
  extend ActiveSupport::Concern
  included do
    alias_method_chain :setting_options, :content_link
  end

  # Adds a content link to the More menu
  def setting_options_with_content_link
    choices       = setting_options_without_content_link
    content_group =
      [
        [_('Products'), :"content/products"],
        [_('Repositories'), :"content/repositories"],
        [_('Content Views'), :"content/content_views"],
        [_('Gpg keys'), :"content/gpg_keys"]
    ]
    choices.insert(3, [:divider], [:group, _("Content"), content_group])
  end
end
