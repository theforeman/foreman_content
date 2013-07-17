module Content
  module Candlepin
    module SynchronizationHandlers
      module Content
        ActiveSupport::Notifications.subscribe('content.repository.create') do |name, start, stop, tid, payload|
          if ::Setting['use_candlepin']
            require 'content/candlepin_amqp'
            ::Content::CandlepinAmqp.publish(
              { "entity"    => "repository",
                "operation" => "create",
                "value"     => payload[:entity] }.to_json(:root => false, :include => [:product]).to_s)
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