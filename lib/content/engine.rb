require 'runcible'

module Content
  ENGINE_NAME = "content"
  class Engine < ::Rails::Engine
    engine_name Content::ENGINE_NAME

    config.autoload_paths += Dir["#{config.root}/app/services"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    # Load this before the Foreman config initializers, so that the Setting.descendants
    # list includes the plugin STI setting class
    initializer 'foreman_content.load_default_settings', :before => :load_config_initializers do |app|
      require_dependency File.expand_path("../../../app/models/setting/content.rb", __FILE__) if (Setting.table_exists? rescue(false))
    end

    initializer "foreman_content.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += Content::Engine.paths['db/migrate'].existent
    end

    # Include extensions to models in this config.to_prepare block
    config.to_prepare do
      # Patch the menu
      ::HomeHelper.send :include, Content::HomeHelper
      # Extend the taxonomy model
      ::Taxonomy.send :include, Content::TaxonomyExtensions
      # Extend the environment model
      ::Environment.send :include, Content::EnvironmentExtensions
      # Extend OS model
      ::Operatingsystem.send :include, Content::OperatingsystemExtensions
      # Extend RedHat OS family model
      ::Redhat.send :include, Content::RedhatExtensions
      # Extend the hostgroup model
      ::Hostgroup.send :include, Content::HostgroupExtensions
      # Extend the host model
      ::Host::Managed.send :include, Content::HostExtensions
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
