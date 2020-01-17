# frozen_string_literal: true

module Decidim
  module OmniauthExtras
    # This is the engine that runs on the public interface of `OmniauthExtras`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      initializer "decidim_omniauth_extras.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::OmniauthExtras::AdminEngine, at: "/admin", as: "decidim_omniauth_extras"
        end
      end

      def load_seed
        nil
      end
    end
  end
end
