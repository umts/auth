# frozen_string_literal: true

require 'omniauth'
require 'omniauth/rails_csrf_protection'
require 'omniauth-entra-id'
require 'rails'

module UMTS
  module Auth
    class Engine < ::Rails::Engine
      initializer 'umts-auth.action_policy' do
        Rails.application.config.action_dispatch.rescue_responses['ActionPolicy::Unauthorized'] = :forbidden
      end

      initializer 'umts-auth.inflection' do
        ActiveSupport::Inflector.inflections do |inflect|
          inflect.acronym 'UMTS'
        end
      end

      initializer 'umts-auth.omniauth' do
        OmniAuth.config.logger = Rails.logger
        OmniAuth.config.request_validation_phase = OmniAuth::AuthenticityTokenProtection.new(key: :_csrf_token)

        Rails.application.config.middleware.use OmniAuth::Builder do
          provider :entra_id, UMTS::Auth.provider
          if Rails.env.development? # simplecov:disable branch
            # simplecov:disable
            provider :developer, fields: %i[uid email first_name last_name], uid_field: :uid
            # simplecov:enable
          end
        end
      end
    end
  end
end
