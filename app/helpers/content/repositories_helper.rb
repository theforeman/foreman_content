module Content
  module RepositoriesHelper

    def sync_status repo
      status = repo.sync_status
      status = if status && status.first
        status.first[:state]
      else
        details = repo.retrieve_with_details
        details[:importers][0][:last_sync] if details && details[:importers] && details[:importers][0]
      end
      "#{time_ago_in_words(status)} ago" rescue status
    rescue
      '-'
    end

    def last_publish details
      return '' unless details[:distributors] && details[:distributors].first && published = details[:distributors].first[:last_publish]
      "#{time_ago_in_words published} ago" rescue ''
    end

    def last_sync details
      return '' unless details[:importers] && details[:importers].first && synced = details[:importers].first[:last_sync]
      "#{time_ago_in_words synced} ago" rescue ''
    end

    def sync_history_times history
      return {} unless history && history.first && summary = history.first['summary']
      return {} unless summary[:comps]
      {
        :comps => summary[:comps][:time_total_sec],
        :errata => summary[:errata][:errata_time_total_sec],
        :packages   => summary[:packages][:time_total_sec]
      }
    end

    def sync_history_metrics history
      return {} unless history && last = history.first
      {
        :updated => last[:updated_count],
        :removed => last[:removed_count],
        :added   => last[:added_count]
      }
    end

    def sync_history_status history
      return {} unless history && last = history.first
      {
        'result'    => last[:result],
        'message'   => last[:error_message] || last['summary']['error'],
        'completed' => ("#{time_ago_in_words(last[:completed])} ago" rescue '')
      }
    end

  end
end