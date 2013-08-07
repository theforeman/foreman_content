module Content
  module ContentViewsHelper

    def repositories(view)
      if view.new_record?
        view.source_repositories + view.repository_clones
      else
        view.repository_clones
      end
    end

    def next_or_cancel path, args={}
      args[:cancel_path] ||= send("#{controller_name}_path")
      content_tag(:div, :class => "form-actions") do
        link_to(_("Cancel"), args[:cancel_path], :class => "btn") + " " +
        submit_tag( _("Next"), :class => "btn btn-primary")
      end
    end

  end
end