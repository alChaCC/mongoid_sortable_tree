module MongoidSortableTree
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.fixture_replacement :factory_girl, dir: "test/test/factories"
    end
  end
end
