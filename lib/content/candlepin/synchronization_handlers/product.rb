module Content
  module Candlepin
    module SynchronizationHandlers
      module Product
        ActiveSupport::Notifications.subscribe('content.product.create') do |name, start, stop, tid, payload|
          if ::Setting['use_candlepin']
            require 'content/candlepin_amqp'
            ::Content::CandlepinAmqp.publish(
              { "entity"    => "product",
                "operation" => "create",
                "value"     => payload[:entity] }.to_json(:root => false).to_s)
          end
        end

        ActiveSupport::Notifications.subscribe('content.product.update') do |name, start, stop, tid, payload|
          # noop
        end

        ActiveSupport::Notifications.subscribe('content.product.destroy') do |name, start, stop, tid, payload|
          # noop
        end
      end
    end
  end
end