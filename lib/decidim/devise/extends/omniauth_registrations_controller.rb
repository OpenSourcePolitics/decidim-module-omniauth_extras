# frozen_string_literal: true
require "active_support/concern"

module Decidim
  module Devise
    module Extends
      module OmniauthRegistrationsController
        extend ActiveSupport::Concern

        included do
          after_action :grant_omniauth_authorization

          private

          def grant_omniauth_authorization
            return unless params[:controller] == "decidim/devise/omniauth_registrations"
            return unless Decidim.authorization_workflows.one?{ |a| a.try(:omniauth_provider) == params[:action] }

            @workflow = Decidim.authorization_workflows.find{ |a| a.try(:omniauth_provider) == params[:action] }

            @form = Decidim::Verifications::Omniauth::OmniauthAuthorizationForm.from_params(user: current_user, provider: @workflow.omniauth_provider)

            @authorization = Decidim::Authorization.find_or_initialize_by(
              user: current_user,
              name: @workflow.name
            )

            Decidim::Verifications::Omniauth::ConfirmOmniauthAuthorization.call(@authorization, @form) do
              on(:ok) do
                flash[:notice] = t("authorizations.new.success", scope: "decidim.verifications.omniauth")
              end
              on(:invalid) do
                flash[:alert] = t("authorizations.new.error", scope: "decidim.verifications.omniauth")
              end
            end

          end
        end
      end
    end
  end
end

Decidim::DeviseControllers.class_eval do
  include Decidim::Devise::Extends::OmniauthRegistrationsController
end
