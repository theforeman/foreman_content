module Content
  class GpgKeysController < ApplicationController
    before_filter :find_by_name, :only => %w{show edit update destroy}

    def index
      @gpg_keys = GpgKey.search_for(params[:search], :order => params[:order]).paginate(:page => params[:page])
    end

    def new
      @gpg_key = GpgKey.new
    end

    def create
      @gpg_key = GpgKey.new(params[:content_gpg_key])
      if @gpg_key.save
        process_success
      else
        process_error
      end
    end

    def edit
    end

    def update
      if @gpg_key.update_attributes(params[:content_gpg_key])
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