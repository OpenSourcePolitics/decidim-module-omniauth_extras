# frozen_string_literal: true
require "active_support/concern"

module Decidim
  module Initiatives
    module InitiativeHelperExtend
      extend ActiveSupport::Concern

      included do

      end
    end
  end
end


Decidim::Initiatives::InitiativeHelper.send(:include, Decidim::Initiatives::InitiativeHelperExtend)
