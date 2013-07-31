module Content
  module Pulp
    module Repository
      extend ActiveSupport::Concern

      included do
        after_initialize :set_pulp_id
        before_validation :set_relative_path
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

      def sync_history
        return unless pulp? && pulp_id
        Runcible::Extensions::Repository.sync_history(pulp_id)
      end

      def delete
        Runcible::Resources::Repository.delete(pulp_id)
      end

      protected
      def set_pulp_id
        self.pulp_id       ||= Foreman.uuid.gsub("-", '')
      end

      def set_relative_path
        self.relative_path ||= custom_repo_path("acme_org", "library", product.name, name)
      end
    end
  end
end
