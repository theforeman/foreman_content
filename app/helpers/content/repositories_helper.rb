module Content
  module RepositoriesHelper

    def last_time(time)
      return if time.blank?
      time_ago_in_words(time) + ' ago'
    end

    def sync_schedule schedules
      return _('None') if schedules.empty?
      schedules.map{|s| s[:schedule]}.join(', ')
    rescue => e
      logger.warn _("Failed to fetch sync schedule: ") + e.to_s
      _('unknown')
    end

    def time_selector f
      html_options   = { :class => 'span1', :disabled => f.object.schedule.blank? }
      f.select(:hour, options_for_time(0..23), {}, html_options) +
        f.select(:minute, options_for_time(0..59), {}, html_options)
    end

    def sync_schedule_selector f
      content_tag :div, :id => 'sync_schedule_form', :class => 'input-prepend input-append' do
        f.select(:interval, [%w(Daily D), %w(Weekly W)], {}, { :disabled => f.object.schedule.blank? , :class => 'span1' }) +
          content_tag(:span, :class => 'add-on') { '@' } +
          time_selector(f)
      end
    end

    private

    def options_for_time(options)
      options.map { |i| [sprintf("%02d", i), i] }
    end

  end
end