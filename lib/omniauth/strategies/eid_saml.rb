require "omniauth-saml"

module OmniAuth
  module Strategies
    class EidSaml < OmniAuth::Strategies::SAML
      option :name, :eid_saml
    end
  end
end
