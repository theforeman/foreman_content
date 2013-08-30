module Content
  class RepositoriesController < ::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :find_repo, :only => %w{show edit update destroy sync}

    def index
      @repositories = Repository.search_for(params[:search], :order => params[:order]).
        paginate(:page => params[:page]).includes(:product, :operatingsystem)
    end

    def new
      @repository = case params[:type]
                    when "operatingsystem"
                      Repository::OperatingSystem.new(:unprotected => true)
                    when "product"
                      Repository::Product.new(:product_id => params[:product_id])
                    else
                      not_found
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

    private

    def find_repo
      @repository = Content::Repository.find(params[:id])
    end
  end
end