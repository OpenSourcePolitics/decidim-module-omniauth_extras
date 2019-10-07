# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic for updating the current
    # organization.
    class UpdateOmniauthSettings < Rectify::Command
      # Public: Initializes the command.
      #
      # organization - The Organization that will be updated.
      # form - A form object with the params.
      def initialize(organization, form)
        @organization = organization
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        return broadcast(:ok, @organization) if update_organization
        broadcast(:invalid)
      end

      private

      attr_reader :form, :organization

      def update_organization
        @organization = Decidim.traceability.update!(
          @organization,
          form.current_user,
          attributes
        )
      end

      def attributes
        { omniauth_settings: form.omniauth_settings }
      end
    end
  end
end
