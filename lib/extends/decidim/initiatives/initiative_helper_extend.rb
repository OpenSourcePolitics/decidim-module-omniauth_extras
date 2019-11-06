# frozen_string_literal: true
require "active_support/concern"

module Decidim
  module Initiatives
    module InitiativeHelperExtend
      extend ActiveSupport::Concern

      included do
        include Decidim::Verifications::MetadataHelper

        def authorizations
          @authorizations ||= Decidim::Verifications::Authorizations.new(
            organization: current_organization,
            user: current_initiative.author,
            granted: true,
            name: (action_authorized_to("create", resource: current_initiative, permissions_holder: current_initiative.type).statuses || []).map { |s| s.handler_name }
          )
        end

        def action_authorized_to(action, resource: nil, permissions_holder: nil)
          action_authorization_cache[action_authorization_cache_key(action, resource, permissions_holder)] ||=
            ::Decidim::ActionAuthorizer.new(current_initiative.author, action, permissions_holder || resource&.component || current_component, resource).authorize
        end

        def action_authorization_cache
          request.env["decidim.action_authorization_cache"] ||= {}
        end

        def action_authorization_cache_key(action, resource, permissions_holder = nil)
          if resource && resource.try(:component) && !resource.permissions.nil?
            "#{action}-#{resource.component.id}-#{resource.resource_manifest.name}-#{resource.id}"
          elsif resource && permissions_holder
            "#{action}-#{permissions_holder.class.name}-#{permissions_holder.id}-#{resource.resource_manifest.name}-#{resource.id}"
          elsif permissions_holder
            "#{action}-#{permissions_holder.class.name}-#{permissions_holder.id}"
          else
            "#{action}-#{current_component.id}"
          end
        end

        def authorization_router(authorization)
          Decidim::Verifications.find_workflow_manifest(@authorizations.first.name).admin_engine.routes.url_helpers
        end

        def metadata_modal_button_to(authorization, html_options, &block)
          html_options ||= {}
          html_options["data-open"] = "authorizationModal"
          html_options["data-open-url"] = authorization_router(authorization).metadata_authorization_path(authorization)
          html_options["onclick"] = "event.preventDefault();"
          send("button_to", "", html_options, &block)
        end
      end
    end
  end
end

Decidim::Initiatives::InitiativeHelper.send(:include, Decidim::Initiatives::InitiativeHelperExtend)
