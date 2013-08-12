module Content
  class ContentViewsController < ::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :find_by_name, :only => %w{show edit update destroy}

    def index
      @content_views = ContentView.search_for(params[:search], :order => params[:order]).
          paginate(:page => params[:page])
      @counter = Repository.group(:content_view_id).where(:content_view_id => @content_views.map(&:id)).count
    end

    def new
      @content_view = ContentView.new
      @content_view.product_id = params[:product] if params[:product]
      @content_view.operatingsystem_id = params[:operatingsystem] if params[:operatingsystem]
    end

    def create
      if params[:content_content_view].delete(:operatingsystem)
        @content_view = ContentView.new(params[:content_content_view])
        redirect_to new_content_view_path(:operatingsystem=>@content_view.operatingsystem_id,:product=>@content_view.product_id)
      else
      @content_view = ContentView.new(params[:content_content_view])
      if @content_view.save
        process_success
      else
        process_error
      end
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