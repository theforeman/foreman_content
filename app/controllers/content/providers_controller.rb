module Content
  class ProvidersController < ::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :find_by_name, :only => %w{show edit update destroy}

    def index
      @providers = Provider.search_for(params[:search], :order => params[:order]).
          paginate(:page => params[:page])
    end

    def new
      @provider = Provider.new
    end

    def create
      attrs = params[:content_provider].merge(params[:content_custom_provider] ||{})
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
      attrs = params[:content_provider].merge(params[:content_custom_provider] ||{})
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