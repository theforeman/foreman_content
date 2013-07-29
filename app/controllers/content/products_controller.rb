module Content
  class ProductsController < ::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :find_by_name, :only => %w{show edit update destroy sync}

    def index
      @products = Product.search_for(params[:search], :order => params[:order]).
          paginate(:page => params[:page]).includes(:repositories)
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(params[:content_product])
      if @product.save
        process_success
      else
        process_error
      end
    end

    def edit
    end

    def update
      if @product.update_attributes(params[:content_product])
        process_success
      else
        process_error
      end
    end

    def sync
      @product.sync
      process_success(:success_msg => _("Successfully started sync for %s") % @product.name)
    rescue => e
      process_error(:error_msg => _("Failed to start sync for %s") % @product.name)
    end

    def destroy
      if @product.destroy
        process_success
      else
        process_error
      end
    end
  end
end