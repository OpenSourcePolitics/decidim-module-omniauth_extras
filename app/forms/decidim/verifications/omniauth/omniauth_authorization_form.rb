# frozen_string_literal: true

module Decidim
  module Verifications
    module Omniauth
      class OmniauthAuthorizationForm < AuthorizationHandler
        attribute :provider, String

        validate :validated

        def metadata
          super.merge(provider: provider)
        end

        def unique_id
          identity_for_user&.uid
        end

        def authorized?
          identity_for_user&.present?
        end

        private

        def validated
          return if authorized?

          errors.add(:uid, I18n.t("decidim.verifications.omniauth.authorizations.new.error"))
        end

        def organization
          current_organization || user.organization
        end

        def identity_for_user
          @identity_for_user ||= Decidim::Identity.find_by(organization: organization, user: user, provider: provider)
        end

      end
    end
  end
end
