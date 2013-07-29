module Content
  class RepositoriesController < ::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :find_by_name, :only => %w{show edit update destroy sync}

    def index
      @repositories = Repository.search_for(params[:search], :order => params[:order]).
        paginate(:page => params[:page]).includes(:product, :operatingsystems)
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

    def show
      @details = @repository.retrieve_with_details
      @sync_history = @repository.sync_history
    rescue
      redirect_back_or_to(edit_repository_path)
    end

    def destroy
      if @repository.destroy
        process_success
      else
        process_error
      end
    end

    def sync
      @repository.sync
      process_success(:success_msg => _("Successfully started sync for %s") % @repository.to_label)
    rescue => e
      process_error(:error_msg => _("Failed to start sync for %s") % @repository.to_label)
    end
  end
end