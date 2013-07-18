module CandlepinCommands
  class Products
    def create(attrs)
      json = Rest::Candlepin::Product.create({ :id => attrs["cp_id"],
        :name => attrs["name"],
        :multiplier => attrs["multiplier"] || 1,
        :attributes => [{:name=>"arch", :value=>"ALL"}]
      })
    end
  end
end
