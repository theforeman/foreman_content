module Repositories
  class Engine < ::Rails::Engine
    engine_name 'repositories'
    isolate_namespace Repositories

    initializer "repositories_engine.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += Repositories::Engine.paths['db/migrate'].existent
    end
  end
end
