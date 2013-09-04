module Content
  module ContentViewsHelper

    def repositories
      cv_repos = @content_view.repository_clones + @content_view.repository_sources

      if @content_view.new_record? && cv_repos.empty? # new form
        @factory.repositories
      else
        cv_repos # edit or new after validation failure
      end
    end

    def next_or_cancel path, args={}
      args[:cancel_path] ||= send("#{controller_name}_path")
      content_tag(:div, :class => "form-actions") do
        link_to(_("Cancel"), args[:cancel_path], :class => "btn") + " " +
        submit_tag( _("Next"), :class => "btn btn-primary")
      end
    end

    def step?
      if params[:type]
        'step1'
      elsif @hostgroup
        'composite'
      else
        'form'
      end
    end

    def options_for_type_selection repo
      options = [[_('Clone (snapshot)'), 'clone']]
      options << [_('Latest'),'latest'] if repo.kind_of?(Content::Repository) && repo.publish?
      selected = 'clone' if @factory # default
      selected ||= @content_view.repository_clone_ids.include?(repo.id) ? 'clone' : 'latest' # on validation error
      options_for_select(options, selected)
    end

  end
end