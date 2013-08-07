module Content
  module ProductsHelper

    def visible? product_id
      @counter[product_id].to_i == 0
    end

  end
end
