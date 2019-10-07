require "omniauth_openid_connect"

module OmniAuth
  module Strategies
    class FranceConnectUid < OmniAuth::Strategies::OpenIDConnect
      info do
        {}
      end
    end
  end
end
