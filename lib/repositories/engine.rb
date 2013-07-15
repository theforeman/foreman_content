require 'repositories_home_helper_patch'
require 'repositories_taxonomy'
require 'repositories/candlepin_synchronization' if false # replace with true to enable Candlepin orchestration

module Repositories
  class Engine < ::Rails::Engine
    engine_name 'repositories'

    initializer "repositories_engine.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += Repositories::Engine.paths['db/migrate'].existent
    end

    # Include extensions to models in this config.to_prepare block
    config.to_prepare do
      # Patch the menu
      ::HomeHelper.send :include, RepositoriesHomeHelperPatch
      # Extend the taxonomy model
      ::Taxonomy.send :include, RepositoriesTaxonomy
    end

  end

  def table_name_prefix
    'repositories_'
  end

  def self.table_name_prefix
    'repositories_'
  end

  def use_relative_model_naming
    true
  end
end
