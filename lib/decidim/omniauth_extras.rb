# frozen_string_literal: true

require "decidim/verifications/extends/workflow_manifest"

require "decidim/omniauth_extras/admin"
require "decidim/omniauth_extras/engine"
require "decidim/omniauth_extras/admin_engine"
require "decidim/verifications/omniauth"

module Decidim
  autoload :OmniauthSettingsJsonbAttributes, "decidim/omniauth_settings_jsonb_attributes"
  # This namespace holds the logic of the `OmniauthExtras` component. This component
  # allows users to create omniauth_extras in a participatory space.
  module OmniauthExtras
  end
end
