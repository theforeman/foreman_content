module Content
  module RepositoriesHelper
    def sync_status status
      "#{time_ago_in_words(status.state)} ago" rescue status.state
    end

    def last_publish details
      return '' unless details[:distributors] && details[:distributors].first && published = details[:distributors].first[:last_publish]
      "#{time_ago_in_words published} ago" rescue ''
    end

    def last_sync status
      "#{time_ago_in_words(status.finish_time)} ago" rescue ''
    end
  end
end
