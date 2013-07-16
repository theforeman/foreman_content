require 'content/candlepin/synchronization_handlers/product'
require 'content/candlepin/synchronization_handlers/content'

module Content
  module Candlepin
    class CandlepinSynchronization
      include SynchronizationHandlers::Product
      include SynchronizationHandlers::Content
    end
  end
end
