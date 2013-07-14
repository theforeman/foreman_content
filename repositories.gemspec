$:.push File.expand_path("../lib", __FILE__)
require "content/version"

Gem::Specification.new do |s|
  s.name        = "content"
  s.version     = Content::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "https://github.com/witlessbird/content-engine"
  s.summary     = "Support for content content."
  s.description = "Support for content content."
  s.licenses = ["GPL-3"]
  s.extra_rdoc_files = [
    "README.md"
  ]

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "bunny", ">= 0.9.0.pre"
  s.add_dependency "logging", ">= 1.8.0"
end
