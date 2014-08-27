module SocialNetworking
  # Mountable engine with isolated namespace.
  class Engine < ::Rails::Engine
    isolate_namespace SocialNetworking

    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end
  end
end
