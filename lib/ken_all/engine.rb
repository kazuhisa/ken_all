module KenAll
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework :rspec
      g.integration_tool :rspec
    end
    isolate_namespace KenAll
  end
end
