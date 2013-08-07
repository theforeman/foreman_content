module Content
  class ContentViewsController < ::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :find_by_name, :only => %w{show edit update destroy}

    def index
      @content_views = ContentView.search_for(params[:search], :order => params[:order]).
          paginate(:page => params[:page])
      @counter = RepositoryClone.joins(:content_view_repository_clones).group(:content_view_id).count

    end

    def new
      @hostgroup = Hostgroup.find_by_id(params[:hostgroup]) if params[:hostgroup]
      @content_view = ContentViewFactory.create_product_content_view(params[:product]) if params[:product]
      @content_view ||= ContentViewFactory.create_os_content_view(params[:operatingsystem]) if params[:operatingsystem]
      @content_view ||= ContentViewFactory.create_composite_content_view(params[:content_content_view_factory]) if params[:content_content_view_factory]
    end

    def create
      @content_view = ContentView.new(params[:content_content_view])
      if @content_view.save
        process_success
      else
        process_error
      end
    end

    def edit
    end

    def update
      if @content_view.update_attributes(params[:content_content_view])
        process_success
      else
        process_error
      end
    end

    def destroy
      if @content_view.destroy
        process_success
      else
        process_error
      end
    end
  end
end