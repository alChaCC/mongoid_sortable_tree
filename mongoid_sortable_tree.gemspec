$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mongoid_sortable_tree/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mongoid_sortable_tree"
  s.version     = MongoidSortableTree::VERSION
  s.authors     = ["Aloha Chen"]
  s.email       = ["y.alohac@gmail.com"]
  s.homepage    = "https://github.com/alChaCC/mongoid-sortable-tree"
  s.summary     = %q{Drag and Drop GUI for mongoid-tree using jstree.}
  s.description = %q{A GUI helper for mongoid-tree(used the materialized path pattern)}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"
  s.add_development_dependency "mongoid"
  s.add_development_dependency "mongoid-tree"
  s.add_development_dependency "jstree-rails-4"
end
