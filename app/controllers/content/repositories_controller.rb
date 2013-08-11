module Content
  class RepositoriesController < ::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :find_by_name, :only => %w{show edit update destroy sync}

    def index
      @repositories = Repository.search_for(params[:search], :order => params[:order]).
        paginate(:page => params[:page]).includes(:product, :operatingsystems)
    end

    def new
      @repository = Repository.new(:unprotected => true)
    end

    def create
      case params[:content_repository][:operatingsystem]
        when "operatingsystem"
          @repository = Repository.new(:unprotected => true, :operatingsystem_id => ::Redhat.first.id)
          redirect_to new_repository_path(:page => "os_form")
        when "product"
          @repository = Repository.new(:unprotected => true, :product_id => Product.first.id)
          redirect_to new_repository_path(:page => "product_form")
        else
          @repository = Repository.new(params[:content_repository])
          if @repository.save
            process_success
          else
            process_error
          end
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