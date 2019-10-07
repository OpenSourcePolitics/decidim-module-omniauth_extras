require "omniauth_openid_connect"

module OmniAuth
  module Strategies
    class FranceConnectProfile < OmniAuth::Strategies::OpenIDConnect
      info do
        {
          name: find_name,
          email: user_info.email,
          nickname: ::Decidim::UserBaseEntity.nicknamize(find_nickname),
          first_name: user_info.given_name,
          last_name: user_info.family_name,
          gender: user_info.gender,
          date_of_birth: user_info.birthdate,
          postal_code: extra.dig(:raw_info,:birthplace)
        }
      end

      def find_name
        "#{user_info.given_name} #{user_info.family_name}"
      end

      def find_nickname
        user_info.preferred_username.blank? ? find_name : user_info.preferred_username
      end
    end
  end
end
