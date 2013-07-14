module Content
  class RepositoriesController < ApplicationController
    before_filter :find_by_name, :only => %w{show edit update destroy}

    def index
      values = Repository.search_for(params[:search], :order => params[:order])
      respond_to do |format|
        format.html { @repositories = values.paginate(:page => params[:page]) }
        format.json { render :json => values }
      end
    end

    def new
      @repository = Repository.new
    end

    def show
      respond_to do |format|
        format.json { render :json => @repository }
      end
    end

    def create
      @repository = Repository.new(params[:content_repository])
      if @repository.save
        process_success
      else
        process_error
      end
    end

    def edit
    end

    def update
      if @repository.update_attributes(params[:content_repository])
        process_success
      else
        process_error
      end
    end

    def destroy
      if @repository.destroy
        process_success
      else
        process_error
      end
    end
  end
end