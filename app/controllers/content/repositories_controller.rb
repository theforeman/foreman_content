module Content
  class RepositoriesController < ::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :find_by_name, :only => %w{show edit update destroy}

    def index
      @repositories = Repository.search_for(params[:search], :order => params[:order]).paginate(:page => params[:page])
    end

    def new
      @repository = Repository.new
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