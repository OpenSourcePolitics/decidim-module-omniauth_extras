# frozen_string_literal: true

require "omniauth/strategies/decidim"
# require "omniauth/strategies/france_connect"
require "omniauth/strategies/france_connect_uid"
require "omniauth/strategies/france_connect_profile"
require "omniauth/strategies/eid_saml"

require "decidim/omniauth_extras/admin"
require "decidim/omniauth_extras/engine"
require "decidim/omniauth_extras/admin_engine"
require "decidim/verifications/omniauth"

module Decidim
  # This namespace holds the logic of the `OmniauthExtras` component. This component
  # allows users to create omniauth_extras in a participatory space.
  module OmniauthExtras
  end
end
