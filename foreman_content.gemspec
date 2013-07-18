$:.push File.expand_path("../lib", __FILE__)
require "content/version"

Gem::Specification.new do |s|
  s.name        = "foreman_content"
  s.version     = Content::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "https://github.com/theforeman/foreman_content"
  s.summary     = "Add Foreman support for content management."
  s.description = "Add Foreman support for software repositories and puppet environments management."
  s.licenses = ["GPL-3"]
  s.extra_rdoc_files = [
    "README.md"
  ]

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "bunny", ">= 0.9.0.pre"
  s.add_dependency "logging", ">= 1.8.0"
  s.add_dependency "runcible", "~> 0.4.10"
end
