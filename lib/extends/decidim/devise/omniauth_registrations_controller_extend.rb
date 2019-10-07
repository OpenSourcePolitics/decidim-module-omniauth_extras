# frozen_string_literal: true
require "active_support/concern"

module Decidim
  module Devise
    module OmniauthRegistrationsControllerExtend
      extend ActiveSupport::Concern

      included do
        prepend_before_action :manage_omniauth_context
        after_action :grant_omniauth_authorization

        private

        def manage_omniauth_context
          return unless params[:controller] == "decidim/devise/omniauth_registrations"
          Rails.logger.debug "+++++++++++++++++++++++++"
          Rails.logger.debug "manage_omniauth_context"
          Rails.logger.debug store_location_for(:user, stored_location_for(:user))
          Rails.logger.debug store_location_for(:redirect, stored_location_for(:redirect))
          Rails.logger.debug "+++++++++++++++++++++++++"

          location = store_location_for(:redirect, stored_location_for(:redirect))
          return unless location.present?

          action = request.params[:action]
          @verified_email = current_user.email if current_user

          encrypted_data = Decidim::AttributeEncryptor.encrypt(oauth_data.to_json.to_s)
          # JSON.parse Decidim::AttributeEncryptor.decrypt(encrypted_data)

          redirect_engine = Decidim::Verifications::Adapter.from_element(action).send("decidim_#{action}")
          redirect_path = redirect_engine.callback_path(
            provider: action,
            data: encrypted_data
          )
          store_location_for(:user, redirect_path)
        end

        def grant_omniauth_authorization
          Rails.logger.debug "+++++++++++++++++++++++++"
          Rails.logger.debug "grant_omniauth_authorization"
          Rails.logger.debug "+++++++++++++++++++++++++"
          return unless params[:controller] == "decidim/devise/omniauth_registrations"
          return unless Decidim.authorization_workflows.one?{ |a| a.try(:omniauth_provider) == params[:action] }

          @workflow = Decidim.authorization_workflows.find{ |a| a.try(:omniauth_provider) == params[:action] }

          @form = Decidim::Verifications::Omniauth::OmniauthAuthorizationForm.from_params(user: current_user, provider: @workflow.omniauth_provider, oauth_data: oauth_data[:info])

          @authorization = Decidim::Authorization.find_or_initialize_by(
            user: current_user,
            name: @workflow.name
          )

          Decidim::Verifications::Omniauth::ConfirmOmniauthAuthorization.call(@authorization, @form) do
            on(:ok) do
              Rails.logger.debug "+++++++++++++++++++++++++"
              Rails.logger.debug "grant_omniauth_authorization OK"
              Rails.logger.debug "+++++++++++++++++++++++++"

              flash[:notice] = t("authorizations.new.success", scope: "decidim.verifications.omniauth")
            end
            on(:invalid) do
              Rails.logger.debug "+++++++++++++++++++++++++"
              Rails.logger.debug "grant_omniauth_authorization KO"
              Rails.logger.debug "+++++++++++++++++++++++++"

              flash[:alert] = t("authorizations.new.error", scope: "decidim.verifications.omniauth")
            end
          end
        end

        def user_params_from_oauth_hash
          return nil if oauth_data.empty?
          {
            provider: oauth_data[:provider],
            uid: oauth_data[:uid],
            name: (oauth_data[:info][:name] || I18n.t("decidim.anonymous_user")),
            nickname: (oauth_data[:info][:nickname] || oauth_data[:uid][0..8]),
            oauth_signature: OmniauthRegistrationForm.create_signature(oauth_data[:provider], oauth_data[:uid]),
            avatar_url: oauth_data[:info][:image],
            raw_data: oauth_hash
          }
        end
      end
    end
  end
end

Decidim::DeviseControllers.class_eval do
  include Decidim::Devise::OmniauthRegistrationsControllerExtend
end
