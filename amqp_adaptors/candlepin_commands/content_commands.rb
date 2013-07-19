module CandlepinCommands
  class Content
    def create(attrs)
      Rest::Candlepin::Content.create({ :id => attrs["id"],
          :name => attrs["name"],
          :contentUrl => attrs["relative_path"].slice(/.*?\/.*?\/(.*)/, 1), # TODO: contentUrl is a subpath of the repo path
          :type => "yum",
          :label =>  attrs["cp_label"],
          :vendor => "Custom" })
      Rest::Candlepin::Product.add_content(attrs["product"]["id"], attrs["id"], true)
    end
  end
end
