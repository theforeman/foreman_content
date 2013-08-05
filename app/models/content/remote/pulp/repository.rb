module Content
  module Remote
    module Pulp
      module Repository
        extend ActiveSupport::Concern

        included do
          after_initialize :initialize_repository
        end

        def pulp?
          @use_pulp ||= Setting.use_pulp and enabled?
        end

        def sync
          Content::Pulp.resources.repository.sync(pulp_id)
        end

        def retrieve_with_details
          return unless pulp? && pulp_id
          Content::Pulp.resources.repository.retrieve(pulp_id, {:details => true})
        end

        def sync_status
          return unless pulp? && pulp_id
          Content::Pulp.extentions.repository.sync_status(pulp_id)
        end

        def sync_history
          return unless pulp? && pulp_id
          Content::Pulp.extentions.repository.sync_history(pulp_id)
        end

        def delete
          Content::Pulp.resources.repository.delete(pulp_id)
        end

        protected
        def initialize_repository
          self.pulp_id       ||= Foreman.uuid.gsub("-", '')
          self.relative_path ||= custom_repo_path("acme_org", "library", product.name, name) if name
        end
      end
    end
  end
end
