# frozen_string_literal: true

require 'rails'

module UMTS
  module Auth
    class SessionsController < ActionController::Base # rubocop:disable Rails/ApplicationController
      def create
        set_session
        redirect_to auth_referer || root_path
      end

      def destroy
        clear_session
        if Rails.env.development? # simplecov:disable branch
          redirect_to root_path # simplecov:disable
        else
          redirect_to entra_logout_url, allow_other_host: true
        end
      end

      private

      def auth_hash = request.env['omniauth.auth']

      def auth_referer = request.env['omniauth.origin'].presence

      def set_session
        session[:entra_uid] = auth_hash.uid
        session[:entra_email] = auth_hash.info.email
        session[:entra_first_name] = auth_hash.info.first_name
        session[:entra_last_name] = auth_hash.info.last_name
        session[:entra_upn] = auth_hash.extra&.raw_info&.upn # simplecov:disable branch
      end

      def clear_session
        session.delete :entra_uid
        session.delete :entra_email
        session.delete :entra_first_name
        session.delete :entra_last_name
        session.delete :entra_upn
      end

      def entra_logout_url
        File.join 'https://login.microsoftonline.com',
                  UMTS::Auth.tenant_id,
                  "oauth2/v2.0/logout?post_logout_redirect_uri=#{CGI.escape(root_url)}"
      end

      class << self
        def after_authenticated(*, &) = after_action(*, only: :create, &)
      end
    end
  end
end
