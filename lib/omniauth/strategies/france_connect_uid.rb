require "omniauth_openid_connect"

module OmniAuth
  module Strategies
    class FranceConnectUid < OmniAuth::Strategies::OpenIDConnect

      option :origin_param, "redirect_url"

      info do
        {
          name: I18n.t("decidim.anonymous_user"),
          nickname: uid[0..8],
          email: ""
        }
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
