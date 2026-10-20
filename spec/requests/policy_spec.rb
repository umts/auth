# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Policies' do
  describe 'GET /an-implicit-endpoint' do
    subject(:call) { get users_path }

    let(:current_user) { create(:user) }

    it 'looks up policies correctly' do
      call
      expect(response).to be_successful
    end
  end

  describe 'GET /a-privileged-endpoint' do
    subject(:call) { get user_path(target_user) }

    let(:target_user) { create(:user) }

    context 'when not authenticated' do
      let(:current_user) { nil }

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated but not authorized' do
      let(:current_user) { create(:user) }

      it 'responds with a forbidden status' do
        expect { call }.to raise_error(ActionPolicy::Unauthorized)
      end
    end

    context 'when authenticated and authorized' do
      let(:current_user) { target_user }

      it 'responds successfully' do
        call
        expect(response).to be_successful
      end
    end
  end
end
