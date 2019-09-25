module Decidim
  module Verifications
    module Extends
      module WorkflowManifest
        extend ActiveSupport::Concern
        
        included do
          attribute :omniauth_provider, String
        end
      end
    end
  end
end

Decidim::Verifications::WorkflowManifest.class_eval do
  include Decidim::Verifications::Extends::WorkflowManifest
end
