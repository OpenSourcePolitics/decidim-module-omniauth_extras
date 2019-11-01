# frozen_string_literal: true
require "active_support/concern"

module Decidim
  module Devise
    module OmniauthRegistrationsControllerExtend
      extend ActiveSupport::Concern

      included do
        prepend_before_action :manage_omniauth_origin, if: :is_omniauth_registration?
        prepend_before_action :manage_omniauth_authorization, if: :is_omniauth_authorization?
        after_action :grant_omniauth_authorization, if: :is_omniauth_registration?
        # append_after_action :sign_out_from_provider, only: [:create], if: :is_omniauth_registration?

        skip_before_action :verify_authenticity_token, if: :is_omniauth_registration?

        private

        def is_omniauth_registration?
          params[:controller] == "decidim/devise/omniauth_registrations"
        end

        def is_omniauth_authorization?
          Rails.logger.debug "+++++++++++++++++++++++++"
          Rails.logger.debug "OmniauthRegistrationsController.is_omniauth_authorization? (before_filters)"
          Rails.logger.debug "request.fullpath --> " + request.fullpath.to_s
          Rails.logger.debug "request.referer --> " + request.referer.to_s
          Rails.logger.debug params
          Rails.logger.debug "omniauth_origin --> " + request.env["omniauth.origin"].to_s
          Rails.logger.debug "location_for :user --> " + store_location_for(:user, stored_location_for(:user)).to_s
          Rails.logger.debug "location_for :redirect --> " + store_location_for(:redirect, stored_location_for(:redirect)).to_s
          Rails.logger.debug "match : " + ( store_location_for(:user, stored_location_for(:user)) =~ /^\/#{params[:action]}\/$/ ).inspect
          Rails.logger.debug "+++++++++++++++++++++++++"

          location = store_location_for(:user, stored_location_for(:user))
          is_omniauth_registration? &&
            location.present? && !!location.match(/^\/#{params[:action]}\/$/)
        end

        def manage_omniauth_origin
          return unless request.env["omniauth.origin"].present?
          return if  request.env["omniauth.origin"].split("?").first == decidim.new_user_session_url.split("?").first
          Rails.logger.debug "+++++++++++++++++++++++++"
          Rails.logger.debug "OmniauthRegistrationsController.manage_omniauth_origin"
          Rails.logger.debug "omniauth_origin --> " + request.env["omniauth.origin"].split("?").first.to_s
          Rails.logger.debug "new_user_session_url --> " + decidim.new_user_session_path.split("?").first.to_s
          Rails.logger.debug "+++++++++++++++++++++++++"
          store_location_for(:user, request.env["omniauth.origin"])
        end

        def manage_omniauth_authorization
          Rails.logger.debug "+++++++++++++++++++++++++"
          Rails.logger.debug "OmniauthRegistrationsController.manage_omniauth_authorization"
          Rails.logger.debug "with current_user" if current_user
          Rails.logger.debug "+++++++++++++++++++++++++"

          if current_user
            @verified_email = current_user.email
          end

          store_location_for(:user, stored_location_for(:redirect))
        end

        def grant_omniauth_authorization
          Rails.logger.debug "+++++++++++++++++++++++++"
          Rails.logger.debug "OmniauthRegistrationsController.grant_omniauth_authorization"
          Rails.logger.debug oauth_data.to_json if oauth_data
          Rails.logger.debug "+++++++++++++++++++++++++"
          return unless Decidim.authorization_workflows.one?{ |a| a.try(:omniauth_provider) == params[:action] }

          # just to be safe
          return unless current_user

          current_user.update_column(:managed, true) if current_user.email.blank?

          @workflow = Decidim.authorization_workflows.find{ |a| a.try(:omniauth_provider) == params[:action] }

          @form = Decidim::Verifications::Omniauth::OmniauthAuthorizationForm.from_params(user: current_user, provider: @workflow.omniauth_provider, oauth_data: oauth_data[:info])

          @authorization = Decidim::Authorization.find_or_initialize_by(
            user: current_user,
            name: @workflow.name
          )

          Decidim::Verifications::Omniauth::ConfirmOmniauthAuthorization.call(@authorization, @form) do
            on(:ok) do
              flash[:notice] = t("authorizations.new.success", scope: "decidim.verifications.omniauth")
            end
            on(:invalid) do
              flash[:alert] = @form.errors.to_h.values.join(' ')
            end
          end
        end

        def sign_out_from_provider
          Rails.logger.debug "+++++++++++++++++++++++++"
          Rails.logger.debug "OmniauthRegistrationsController.sign_out_from_provider"
          Rails.logger.debug "+++++++++++++++++++++++++"
        end
      end
    end
  end
end

# Decidim::DeviseControllers.class_eval do
#   include Decidim::Devise::OmniauthRegistrationsControllerExtend
# end

::Devise::OmniauthCallbacksController.send(:include,Decidim::Devise::OmniauthRegistrationsControllerExtend)
