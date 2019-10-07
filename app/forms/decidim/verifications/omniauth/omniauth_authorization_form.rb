# frozen_string_literal: true

module Decidim
  module Verifications
    module Omniauth
      class OmniauthAuthorizationForm < AuthorizationHandler
        attribute :provider, String
        attribute :oauth_data, Hash

        validate :validated

        def metadata
          super.merge(provider: provider).merge(oauth_data)
        end

        def unique_id
          identity_for_user&.uid
        end

        def authorized?
          identity_for_user&.present?
        end

        def form_attributes
          super - [:provider, :oauth_data]
        end

        def to_partial_path
          handler_name.sub!(/_form$/, "") + "/form"
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

        def _clean_hash(data)
          data.delete_if {|k,v| ((v.is_a? Hash) ? _clean_hash(v) : v).blank?}
        end

      end
    end
  end
end
