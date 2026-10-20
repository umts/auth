# frozen_string_literal: true

require 'omniauth'
require 'rspec/rails'

module UMTS
  module Auth
    module RSpec
      extend ActiveSupport::Concern

      included do
        let(:current_user) { nil }

        if self <= ::RSpec::Rails::RequestExampleGroup || self <= ::RSpec::Rails::SystemExampleGroup
          before { login_as(current_user) if current_user.present? }
        else
          around { |example| Current.set(user: current_user) { example.run } }
        end
      end

      def login_as(user)
        case self
        when ::RSpec::Rails::RequestExampleGroup
          rack_login_as(user)
        when ::RSpec::Rails::SystemExampleGroup
          capybara_login_as(user)
        else
          current_login_as(user)
        end
      end

      private

      def current_login_as(user)
        Current.user = user
      end

      def rack_login_as(user)
        OmniAuth.config.mock_auth[:entra_id] = OmniAuth::AuthHash.new(uid: user.entra_uid)
        get '/auth/entra_id/callback'
      end

      def capybara_login_as(user)
        OmniAuth.config.mock_auth[:entra_id] = OmniAuth::AuthHash.new(uid: user.entra_uid)
        current_url.tap do |original_url|
          visit '/auth/entra_id/callback'
          visit original_url
        end
      end
    end
  end
end

OmniAuth.config.test_mode = true
RSpec.configuration.include UMTS::Auth::RSpec
