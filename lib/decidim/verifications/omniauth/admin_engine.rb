# frozen_string_literal: true

module Decidim
  module Verifications
    module Omniauth
      class AdminEngine < ::Rails::Engine
        isolate_namespace Decidim::Verifications::Omniauth::Admin

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil

        routes do
          resources :census, only: [:index, :create] do
            collection do
              delete :destroy_all
            end
          end
          root to: "census#index"
        end
      end
    end
  end
end
