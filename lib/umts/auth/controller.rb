# frozen_string_literal: true

require 'action_policy'

module UMTS
  module Auth
    module Controller
      extend ActiveSupport::Concern

      included do
        before_action :set_current_user
        authorize :request, through: :request
        authorize :user, through: -> { Current.user }
        verify_authorized
        rescue_from ActionPolicy::Unauthorized, with: :handle_unauthorized
      end

      protected

      def implicit_authorization_target = self.class.controller_path.to_sym

      private

      def set_current_user
        Current.user = User.find_by(entra_uid: session[:entra_uid])
      end

      def handle_unauthorized(error)
        raise error if session[:entra_uid].present?

        if !request.format.html? || Rails.env.test?
          head :unauthorized
        # simplecov:disable
        elsif Rails.env.development?
          render 'development_login', layout: 'umts/brand/bare', status: :unauthorized
        else
          render 'umts/auth/production_login', layout: false, status: :unauthorized
        end
        # simplecov:enable
      end
    end
  end
end
