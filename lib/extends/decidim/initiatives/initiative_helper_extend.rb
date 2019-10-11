# frozen_string_literal: true

# frozen_string_literal: true

module Decidim
  module Initiatives
    module InitiativeHelperExtend
      def available_online_signature_types
        [:devise] + available_omniauth_signature_types
      end

      def available_omniauth_signature_types
        Decidim::User.omniauth_providers.select {
          |provider| Rails.application.secrets.dig(:omniauth, provider.to_sym, :enabled)
        }
      end

      def available_online_signature_options
        available_online_signature_types.map do |key|
          {
            name: I18n.t(
              key,
              scope: %w(decidim initiatives online_signature_type_options)
            ),
            value: key
          }
        end
      end
    end
  end
end


Decidim::Initiatives::InitiativeHelper.send(:include, Decidim::Initiatives::InitiativeHelperExtend)
