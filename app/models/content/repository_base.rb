module Content
  class RepositoryBase < ActiveRecord::Base
    include CustomRepositoryPaths

    set_table_name "content_repositories"

    attr_reader :pulp

    def update_cache; nil; end
    def progress_report_id
      @progress_report_id ||= Foreman.uuid
    end
  end
end
