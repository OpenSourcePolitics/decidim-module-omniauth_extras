# frozen_string_literal: true

module Decidim
  module OmniauthExtras
    # This is the engine that runs on the public interface of `OmniauthExtras`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        constraints(->(request) { Decidim::Admin::OrganizationDashboardConstraint.new(request).matches? }) do
          resource :omniauth_settings, only: [:edit, :update], controller: "omniauth_settings"
        end
      end

      initializer "decidim_omniauth_extras.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::OmniauthExtras::AdminEngine, at: "/admin", as: "decidim_omniauth_extras"
        end
      end

      initializer "decidim_omniauth_extras.menu" do
        Decidim.menu :admin_menu do |menu|
          menu_settings = menu.items.find do |item|
            item.label == I18n.t("menu.settings", scope: "decidim.admin")
          end
          menu_settings.active << "decidim/admin/omniauth"
        end

        Decidim.menu :admin_settings_menu do |menu|
          menu.item I18n.t("menu.omniauth_settings", scope: "decidim.admin"),
                    decidim_omniauth_extras.edit_omniauth_settings_path,
                    position: 10,
                    active: [%w(decidim/admin/omniauth_settings), []],
                    if: allowed_to?(:update, :organization, organization: current_organization)
        end
      end

      def load_seed
        nil
      end
    end
  end
end
