module Content
  module Remote
    module Pulp
      module Repository
        extend ActiveSupport::Concern

        included do
          after_initialize :initialize_pulp
        end

        def pulp?
          @use_pulp ||= Setting.use_pulp and enabled?
        end

        def sync
          Runcible::Resources::Repository.sync(pulp_id)
        end

        def retrieve_with_details
          return unless pulp? && pulp_id
          Runcible::Resources::Repository.retrieve(pulp_id, {:details => true})
        end

        def sync_status
          return unless pulp? && pulp_id
          Runcible::Extensions::Repository.sync_status(pulp_id)
        end

        def sync_history
          return unless pulp? && pulp_id
          Runcible::Extensions::Repository.sync_history(pulp_id)
        end

        def delete
          Runcible::Resources::Repository.delete(pulp_id)
        end

        protected
        def initialize_pulp
          # initiate pulp connection
          Content::PulpConfiguration.new
          self.pulp_id       ||= Foreman.uuid.gsub("-", '')
          self.relative_path ||= custom_repo_path("acme_org", "library", product.name, name) if name
        end
      end
    end
  end
end
