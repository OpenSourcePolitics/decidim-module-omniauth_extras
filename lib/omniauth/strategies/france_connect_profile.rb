require "omniauth_openid_connect"

module OmniAuth
  module Strategies
    class FranceConnectProfile < OmniAuth::Strategies::OpenIDConnect

      option :origin_param, "redirect_url"

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

      def authorize_uri
        super + (options.acr_values.present? ? "&acr_values=#{options.acr_values}" : "")
      end

      private

      def redirect_uri
        return omniauth_callback_url unless params["redirect_uri"]

        "#{ omniauth_callback_url }?redirect_uri=#{ CGI.escape(params["redirect_uri"]) }"
      end

      def omniauth_callback_url
        # client_options.redirect_uri unless client_options.redirect_uri.blank?
        full_host + script_name + callback_path
      end
    end
  end
end
