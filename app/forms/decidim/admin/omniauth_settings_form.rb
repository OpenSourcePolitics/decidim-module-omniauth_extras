# frozen_string_literal: true

module Decidim
  module Admin
    # A form object used to update the omniauth settings from the admin
    # dashboard.
    #
    class OmniauthSettingsForm < Form
      include TranslatableAttributes
      include JsonbAttributes
      include OmniauthSettingsJsonbAttributes

      mimic :organization

      omniauth_settings_jsonb_attribute :omniauth_settings, Decidim::User.omniauth_providers.select {
        |provider| Rails.application.secrets.dig(:omniauth, provider.to_sym, :enabled)
      }

    end
  end
end
