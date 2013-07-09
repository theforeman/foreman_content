module Repositories
  class GpgKeysController < ApplicationController
    before_filter :find_by_name, :only => %w{show edit update destroy}

    def index
      values = GpgKey.search_for(params[:search], :order => params[:order])
      respond_to do |format|
        format.html { @gpg_keys = values.paginate(:page => params[:page]) }
        format.json { render :json => values }
      end
    end

    def new
      @gpg_key = GpgKey.new
    end

    def show
      respond_to do |format|
        format.json { render :json => @gpg_key }
      end
    end

    def create
      @gpg_key = GpgKey.new(params[:repositories_gpg_key])
      if @gpg_key.save
        process_success
      else
        process_error
      end
    end

    def edit
    end

    def update
      if @gpg_key.update_attributes(params[:repositories_gpg_key])
        process_success
      else
        process_error
      end
    end

    def destroy
      if @gpg_key.destroy
        process_success
      else
        process_error
      end
    end
  end
end