module Content
  class ContentViewsController < ::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :find_by_name, :only => %w{show edit update destroy}

    def index
      @content_views = ContentView.search_for(params[:search], :order => params[:order]).
        paginate(:page => params[:page])
      @counter       = ContentViewRepositoryClone.where(:content_view_id => @content_views.map(&:id)).group(:content_view_id).count

    end

    def show
    end

    def new
      options = if params[:product]
                  {:originator_id => params[:product], :originator_type => 'Content::Product'}
                elsif params[:operatingsystem]
                  {:originator_id => params[:operatingsystem], :originator_type => 'Operatingsystem'}
                elsif params[:hostgroup]
                  @hostgroup = Hostgroup.find_by_id(params[:hostgroup])
                  {:originator_id => params[:hostgroup], :originator_type => 'Hostgroup'}
                elsif params[:content_content_view_factory]
                  params[:content_content_view_factory]
                elsif params[:type].blank?
                  process_error(:error_msg => _('Must provide a type'))
                end
      @factory = ContentViewFactory.new(options || {})
      @content_view = @factory.try(:content_view) if @factory.originator_id
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