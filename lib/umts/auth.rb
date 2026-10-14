# frozen_string_literal: true

require_relative 'auth/engine'
require_relative 'auth/version'

module UMTS
  module Auth
    class << self
      def tenant_id = '7bd08b0b-3395-4dc1-94bb-d0b2e56a497f'

      def provider = { tenant_id:, client_id:, client_secret: }

      private

      def client_id = creds :entra_id, :client_id

      def client_secret = creds :entra_id, :client_secret

      # TODO: Replace usages with creds api once on rails 8.2.
      def creds(*keys) = ENV.fetch(keys.join('__').upcase, Rails.application.credentials.dig(*keys))
    end
  end
end
