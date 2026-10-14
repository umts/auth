# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  let(:session_values) do
    { entra_uid: 'my-uid',
      entra_email: 'email@test.com',
      entra_first_name: 'Bobo',
      entra_last_name: 'Test',
      entra_upn: 'bobo-test' }
  end

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:entra_id] = OmniAuth::AuthHash.new(
      uid: 'my-uid',
      info: { email: 'email@test.com', first_name: 'Bobo', last_name: 'Test' },
      extra: { raw_info: { upn: 'bobo-test' } }
    )
  end

  describe 'GET /auth/:provider/callback' do
    subject(:call) { get '/auth/entra_id/callback', env: }

    let(:env) { {} }

    it 'sets session values' do
      call
      expect(session.to_h.symbolize_keys).to include(session_values)
    end

    context 'with no omniauth origin' do
      it 'redirects to the root path' do
        call
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with an omniauth origin' do
      let(:env) { { 'omniauth.origin' => '/redirect_path' } }

      it 'redirects to the origin' do
        call
        expect(response).to redirect_to('/redirect_path')
      end
    end
  end

  describe 'POST /logout' do
    subject(:submit) { post '/logout' }

    let(:session_keys) { %i[entra_uid entra_email entra_first_name entra_last_name entra_upn] }

    before { get '/auth/entra_id/callback' }

    it 'clears entra data from the session' do
      expect { submit }.to change { session.to_h.symbolize_keys.slice(*session_keys) }.from(session_values).to({})
    end

    it 'redirects you to the entra logout url' do
      submit
      expect(response).to redirect_to(
        File.join('https://login.microsoftonline.com',
                  UMTS::Auth.tenant_id,
                  "oauth2/v2.0/logout?post_logout_redirect_uri=#{CGI.escape(root_url)}")
      )
    end
  end
end
