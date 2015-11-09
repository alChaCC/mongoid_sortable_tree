$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mongoid_sortable_tree/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mongoid_sortable_tree"
  s.version     = MongoidSortableTree::VERSION
  s.authors     = ["aloha"]
  s.email       = ["y.alohac@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of MongoidSortableTree."
  s.description = "TODO: Description of MongoidSortableTree."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"
end
