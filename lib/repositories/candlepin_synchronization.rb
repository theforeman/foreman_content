module Repositories
  class CandlepinSynchronization
    ActiveSupport::Notifications.subscribe('repositories.product.create') do |name, start, stop, tid, payload|
      Repositories::CandlepinAmqp.publish(
          {"entity" => "product",
           "operation" => "create",
           "value" => payload[:entity]}.to_json(:root => false).to_s)
    end

    ActiveSupport::Notifications.subscribe('repositories.product.update') do |name, start, stop, tid, payload|
      # noop
    end

    ActiveSupport::Notifications.subscribe('repositories.product.destroy') do |name, start, stop, tid, payload|
      # noop
    end
  end
end
