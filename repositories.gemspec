Gem::Specification.new do |s|
  s.name        = "repositories"
  s.version     = "0.0.1"
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "http://theforeman.org"
  s.summary     = "Support for content repositories."
  s.description = "Support for content repositories."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]
end
