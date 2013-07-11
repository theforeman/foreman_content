module Repositories
  class ProvidersController < ApplicationController
    before_filter :find_by_name, :only => %w{show edit update destroy}

    def index
      values = Provider.search_for(params[:search], :order => params[:order])
      respond_to do |format|
        format.html { @providers = values.paginate(:page => params[:page]) }
        format.json { render :json => values }
      end
    end

    def new
      @provider = Provider.new
    end

    def show
      respond_to do |format|
        format.json { render :json => @provider }
      end
    end

    def create
      attrs = params[:repositories_provider].merge(params[:repositories_custom_provider] ||{})
      @provider = Provider.new_provider(attrs)
      if @provider.save
        process_success
      else
        process_error
      end
    end

    def edit
    end

    def update
      attrs = params[:repositories_provider].merge(params[:repositories_custom_provider] ||{})
      if @provider.update_attributes(attrs)
        process_success
      else
        process_error
      end
    end

    def destroy
      if @provider.destroy
        process_success
      else
        process_error
      end
    end
  end
end