# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Policies' do
  describe 'GET /an-implicit-endpoint' do
    subject(:call) { get users_path }

    let(:user) do
      User.create!(entra_uid: 'bobo-test',
                   entra_upn: 'bobo@test.com',
                   first_name: 'Bobo',
                   last_name: 'Test',
                   email: 'bobo@test.com')
    end

    before do
      OmniAuth.config.mock_auth[:entra_id] = OmniAuth::AuthHash.new(uid: user.entra_uid)
      get '/auth/entra_id/callback'
    end

    it 'looks up policies correctly' do
      call
      expect(response).to be_successful
    end
  end

  describe 'GET /a-privileged-endpoint' do
    subject(:call) { get user_path(target_user) }

    let(:target_user) do
      User.create!(entra_uid: 'bobo-test',
                   entra_upn: 'bobo@test.com',
                   first_name: 'Bobo',
                   last_name: 'Test',
                   email: 'bobo@test.com')
    end
    let(:other_user) do
      User.create!(entra_uid: 'gobo-test',
                   entra_upn: 'gobo@test.com',
                   first_name: 'Gobo',
                   last_name: 'Test',
                   email: 'gobo@test.com')
    end

    context 'when not authenticated' do
      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated but not authorized' do
      before do
        OmniAuth.config.mock_auth[:entra_id] = OmniAuth::AuthHash.new(uid: other_user.entra_uid)
        get '/auth/entra_id/callback'
      end

      it 'responds with a forbidden status' do
        expect { call }.to raise_error(ActionPolicy::Unauthorized)
      end
    end

    context 'when authenticated and authorized' do
      before do
        OmniAuth.config.mock_auth[:entra_id] = OmniAuth::AuthHash.new(uid: target_user.entra_uid)
        get '/auth/entra_id/callback'
      end

      it 'responds successfully' do
        call
        expect(response).to be_successful
      end
    end
  end
end
