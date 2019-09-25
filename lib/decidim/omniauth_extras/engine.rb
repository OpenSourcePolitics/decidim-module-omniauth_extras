# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module OmniauthExtras
    # This is the engine that runs on the public interface of omniauth_extras.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::OmniauthExtras

      routes do
        # Add engine routes here
        # resources :omniauth_extras
        # root to: "omniauth_extras#index"
      end

      initializer "decidim_omniauth_extras.assets" do |app|
        app.config.assets.precompile += %w[decidim_omniauth_extras_manifest.js decidim_omniauth_extras_manifest.css]
      end
    end
  end
end
