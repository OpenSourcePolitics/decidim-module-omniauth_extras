# frozen_string_literal: true

module Decidim
  module Admin
    class OmniauthSettingsController < Decidim::Admin::ApplicationController
      layout "decidim/admin/settings"

      def edit
        enforce_permission_to :update, :organization, organization: current_organization
      end

      def update
        enforce_permission_to :update, :organization, organization: current_organization
        @form = form(OmniauthSettingsForm).from_params(params)

        UpdateOmniauthSettings.call(current_organization, @form) do
          on(:ok) do
            flash[:notice] = I18n.t("organization.update.success", scope: "decidim.admin")
            redirect_to edit_organization_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("organization.update.error", scope: "decidim.admin")
            render :edit
          end
        end
      end
    end
  end
end