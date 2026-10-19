# frozen_string_literal: true

module UMTS
  module Auth
    module Policy
      extend ActiveSupport::Concern

      included do
        authorize :request
        authorize :user, allow_nil: true
        alias_rule :create?, to: :manage?
        alias_rule :new?, to: :create?
        alias_rule :edit?, to: :update?
      end
    end
  end
end
