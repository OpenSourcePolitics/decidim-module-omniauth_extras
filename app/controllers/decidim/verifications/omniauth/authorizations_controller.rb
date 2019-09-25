# frozen_string_literal: true

module Decidim
  module Verifications
    module Omniauth
      class AuthorizationsController < Decidim::ApplicationController
        helper_method :authorization

        before_action :load_authorization

        def new
          @form = OmniauthAuthorizationForm.from_params(user: current_user, provider: provider)
          ConfirmOmniauthAuthorization.call(@authorization, @form) do
            on(:ok) do
              flash[:notice] = t("authorizations.new.success", scope: "decidim.verifications.omniauth")
            end
            on(:invalid) do
              flash[:alert] = t("authorizations.new.error", scope: "decidim.verifications.omniauth")
            end
            redirect_to decidim_verifications.authorizations_path
          end
        end

        private

        def authorization
          @authorization ||= AuthorizationPresenter.new(@authorization)
        end

        def load_authorization
          @authorization = Decidim::Authorization.find_or_initialize_by(
            user: current_user,
            name: handler_name
          )
        end

        def handler_name
          @handler_name ||= url_options[:script_name].split("/").detect(&:present?)
        end

        def handler
          @handler ||= Decidim::Verifications.find_workflow_manifest(handler_name)
        end

        def provider
          @provider ||= handler.omniauth_provider
        end
      end
    end
  end
end
