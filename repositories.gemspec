$:.push File.expand_path("../lib", __FILE__)
require "repositories/version"

Gem::Specification.new do |s|
  s.name        = "repositories"
  s.version     = Repositories::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "https://github.com/witlessbird/repositories-engine"
  s.summary     = "Support for content repositories."
  s.description = "Support for content repositories."
  s.licenses = ["GPL-3"]
  s.extra_rdoc_files = [
    "README.md"
  ]

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 3.2.13"
end
