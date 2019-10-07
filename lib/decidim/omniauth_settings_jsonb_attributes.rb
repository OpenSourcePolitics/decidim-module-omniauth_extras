# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module OmniauthSettingsJsonbAttributes
    extend ActiveSupport::Concern

    class_methods do
      def omniauth_settings_jsonb_attribute(name, fields, *options)
        jsonb_attribute name, fields, default: {}

        fields.each do |provider|
          provider = provider.to_sym
          jsonb_attribute provider, Rails.application.secrets.dig(:omniauth, provider.to_sym).keys.map do |e|
            [e,
              case e
              when :enabled
                Virtus::Attribute::Boolean
              else
                String
              end
            ]
          end

          define_method provider do
            field = public_send(name) || {}
            field[provider.to_s] || field[provider.to_sym]
          end

          define_method "#{provider}=" do |value|
            field = public_send(name) || {}
            public_send("#{name}=", field.merge(provider => super(value)))
          end
        end
      end
    end
  end
end
