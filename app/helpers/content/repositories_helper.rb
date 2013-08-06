module Content
  module RepositoriesHelper

    def last_time(time)
      return if time.blank?
      time_ago_in_words(time) + ' ago'
    end

  end
end