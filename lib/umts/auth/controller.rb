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
        rescue_from ActionPolicy::Unauthorized do |exception|
          if session[:entra_uid].present?
            raise exception
            # simplecov:disable
          elsif request.format.html? && Rails.env.production?
            render 'umts/auth/production_login', layout: false, status: :unauthorized
          elsif request.format.html? && Rails.env.development?
            render 'development_login', layout: 'umts/brand/bare', status: :unauthorized
            # simplecov:enable
          else
            head :unauthorized
          end
        end
      end

      protected

      def implicit_authorization_target = self.class.controller_path.to_sym

      private

      def set_current_user
        Current.user = User.find_by(entra_uid: session[:entra_uid])
      end
    end
  end
end
