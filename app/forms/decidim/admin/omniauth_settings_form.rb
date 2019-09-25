# frozen_string_literal: true

module Decidim
  module Admin
    # A form object used to update the omniauth settings from the admin
    # dashboard.
    #
    class OmniauthSettingsForm < Form
      include TranslatableAttributes

      mimic :organization

      jsonb_attribute :omniauth_settings, [
        [:provider, String],
        [:enabled, String],
        [:config, String]
      ]

    end
  end
end
