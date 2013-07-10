module Repositories
  class ProductsController < ApplicationController
    before_filter :find_by_name, :only => %w{show edit update destroy}

    def index
      values = Product.search_for(params[:search], :order => params[:order])
      respond_to do |format|
        format.html { @products = values.paginate(:page => params[:page]) }
        format.json { render :json => values }
      end
    end

    def new
      @product = Product.new
    end

    def show
      respond_to do |format|
        format.json { render :json => @product }
      end
    end

    def create
      @product = Product.new(params[:repositories_product])
      if @product.save
        process_success
      else
        process_error
      end
    end

    def edit
    end

    def update
      if @product.update_attributes(params[:repositories_product])
        process_success
      else
        process_error
      end
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