require 'capistrano'

module Capistrano::Recipes
  module Bark
    def self.load_into(configuration)
      configuration.load do
        task :bark do
          set :message, 'ruff ruff'
          message
        end
      end
    end
  end
end
