# frozen_string_literal: true
require "active_support/concern"

module Decidim
  module Verifications
    module Omniauth
      module WorkflowManifestExtend
        extend ActiveSupport::Concern

        included do
          attribute :omniauth_provider, String
          attribute :minimum_age, Integer, default: 0
        end
      end
    end
  end
end

Decidim::Verifications::WorkflowManifest.class_eval do
  include Decidim::Verifications::Omniauth::WorkflowManifestExtend
end
