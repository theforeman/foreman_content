require 'content_home_helper_patch'
require 'content_taxonomy'
require 'content/candlepin_synchronization' if false # replace with true to enable Candlepin orchestration

module Content
  ENGINE_NAME = "content"
  class Engine < ::Rails::Engine
    engine_name Content::ENGINE_NAME

    initializer "content_engine.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += Content::Engine.paths['db/migrate'].existent
    end

    # Include extensions to models in this config.to_prepare block
    config.to_prepare do
      # Patch the menu
      ::HomeHelper.send :include, ContentHomeHelperPatch
      # Extend the taxonomy model
      ::Taxonomy.send :include, ContentTaxonomy
    end
  end

  def table_name_prefix
    Content::ENGINE_NAME + '_'
  end

  def self.table_name_prefix
    Content::ENGINE_NAME + '_'
  end

  def use_relative_model_naming
    true
  end

end
