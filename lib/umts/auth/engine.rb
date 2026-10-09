# frozen_string_literal: true

require 'omniauth'
require 'omniauth/rails_csrf_protection'
require 'omniauth-entra-id'
require 'rails'

module UMTS
  module Auth
    class Engine < ::Rails::Engine
      initializer 'umts-auth.inflection' do
        ActiveSupport::Inflector.inflections do |inflect|
          inflect.acronym 'UMTS'
        end
      end

      initializer 'umts-auth.omniauth' do
        OmniAuth.config.logger = Rails.logger
        OmniAuth.config.request_validation_phase = OmniAuth::AuthenticityTokenProtection.new(key: :_csrf_token)

        Rails.application.config.middleware.use OmniAuth::Builder do
          provider :entra_id, { tenant_id: UMTS::Auth.tenant_id }.merge(Rails.application.credentials[:entra_id] || {})
          provider :developer, fields: %i[uid email first_name last_name], uid_field: :uid unless Rails.env.production?
        end
      end
    end
  end
end
