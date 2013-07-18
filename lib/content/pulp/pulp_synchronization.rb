require 'content/pulp/synchronization_handlers/repository'

module Content
  module Pulp
    class PulpSynchronization
      include SynchronizationHandlers::Repository
    end
  end
end
