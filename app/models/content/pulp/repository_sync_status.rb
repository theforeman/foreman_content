module Content
  module Pulp
    class RepositorySyncStatus
      attr_reader :state, :progress, :finish_time, :start_time, :sync_times, :sync_metrics, :message

      HISTORY_ERROR = "failed"
      HISTORY_SUCCESS = "success"
      FINISHED  = "finished"
      ERROR     = "error"
      RUNNING   = "running"
      WAITING   = "waiting"
      CANCELED  = "canceled"
      NOT_SYNCED = "not synchronized"

      def initialize(attrs)
        @state = NOT_SYNCED
        @progress = @finish_time = @start_time = @message = ''
        @sync_times = @sync_metrics = {}

        attrs.each do |k, v|
          instance_variable_set("@#{k}", v) if respond_to?("#{k}".to_sym)
        end
      end

      def self.for_repository(pulp_id)
        self._get_most_recent_sync_status(pulp_id)
      end

      def synced?
        state == FINISHED
      end

      protected

      def self._get_most_recent_sync_status(pulp_id)
        history = convert_history(Runcible::Extensions::Repository.sync_history(pulp_id))

        if history.nil? or history.empty?
          return RepositorySyncStatus.new(:state => NOT_SYNCED)
        else
          history = sort_sync_status(history)
          return RepositorySyncStatus.new(history.first.with_indifferent_access)
        end
#      rescue => e
#        RepositorySyncStatus.new({:state => "not available"})
      end

      def self.sort_sync_status statuses
        statuses.sort!{|a,b|
          if a['finish_time'].nil? && b['finish_time'].nil?
            if a['start_time'].nil?
              1
            elsif b['start_time'].nil?
              -1
            else
              a['start_time'] <=> b['start_time']
            end
          elsif a['finish_time'].nil?
            if a['start_time'].nil?
              1
            else
              -1
            end
          elsif b['finish_time'].nil?
            if b['start_time'].nil?
              -1
            else
              1
            end
          else
            b['finish_time'] <=> a['finish_time']
          end
        }
        return statuses
      end

      def self.convert_history(history_list)
        #history item attributes
        #["_id", "_ns", "added_count", "completed", "details", "error_message", "exception", "id",
        # "importer_id", "importer_type_id", "removed_count", "repo_id", "result", "started", "summary",
        # "traceback", "updated_count"]

        #task status attributes
        #["task_group_id", "exception", "traceback", "_href", "task_id", "call_request_tags", "reasons",
        # "start_time", "tags", "state", "finish_time", "dependency_failures", "schedule_id", "progress",
        # "call_request_group_id", "call_request_id", "principal_login", "response", "result"]
        history_list.collect do |history|
          result = history['result']
          result = ERROR if result == HISTORY_ERROR
          result = FINISHED if result == HISTORY_SUCCESS

          {
              :state =>  result,
              :progress => {:details=> history['details']},
              :finish_time => history['completed'],
              :start_time => history['started'],
              :sync_times => parse_sync_times(history),
              :sync_metrics => parse_sync_metrics(history),
              :message => history['error_message'] || history['summary']['error']
          }.with_indifferent_access
        end
      end

      def self.parse_sync_times(history)
        if (summary = history.try(:fetch, 'summary')).try(:fetch, 'comps').nil?
          {}
        else
          {
            :comps => summary['comps']['time_total_sec'],
            :errata => summary['errata']['errata_time_total_sec'],
            :packages   => summary['packages']['time_total_sec']
          }
        end
      end

      def self.parse_sync_metrics(history)
        {
          :updated => history['updated_count'],
          :removed => history['removed_count'],
          :added   => history['added_count']
        }
      end
    end
  end
end
