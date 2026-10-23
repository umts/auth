# frozen_string_literal: true

require 'action_policy'

module UMTS
  module Auth
    module Current
      extend ActiveSupport::Concern

      included do
        attribute :user

        def user=(user)
          PaperTrail.request.whodunnit = user&.id if defined?(PaperTrail)
          super
        end

        resets do
          PaperTrail.request.whodunnit = nil if defined?(PaperTrail)
        end
      end
    end
  end
end
