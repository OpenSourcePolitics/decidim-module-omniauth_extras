# frozen_string_literal: true

Decidim::Verifications.register_workflow(:omniauth_decidim) do |workflow|
  workflow.engine = Decidim::Verifications::Omniauth::Engine
  workflow.admin_engine = Decidim::Verifications::Omniauth::AdminEngine
  workflow.omniauth_provider = :decidim
  workflow.expires_in = 1.month
end
