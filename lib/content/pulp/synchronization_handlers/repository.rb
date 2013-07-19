module Content
  module Pulp
    module SynchronizationHandlers
      module Repository
        ActiveSupport::Notifications.subscribe('content.repository.create') do |name, start, stop, tid, payload|
          if ::Setting['use_pulp']
            require 'content/pulp_amqp'
            ::Content::PulpAmqp.publish(
              { "entity"    => "repository",
                "operation" => "create",
                "value"     => payload[:entity] }.to_json(:root => false).to_s)
          end
        end

        ActiveSupport::Notifications.subscribe('content.repository.update') do |name, start, stop, tid, payload|
          # noop
        end

        ActiveSupport::Notifications.subscribe('content.repository.destroy') do |name, start, stop, tid, payload|
          # noop
        end
      end
    end
  end
end
