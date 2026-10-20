# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UMTS::Auth::RSpec do # rubocop:disable RSpec/MultipleDescribes
  context 'with no current user' do
    let(:current_user) { nil }

    it 'does not log in' do
      expect(Current.user).to be_nil
    end
  end

  context 'with a current user' do
    let(:current_user) do
      User.create!(entra_uid: 'bobo-test',
                   entra_upn: 'bobo@test.com',
                   first_name: 'Bobo',
                   last_name: 'Test',
                   email: 'bobo@test.com')
    end

    it 'logs in' do
      expect(Current.user).to be(current_user)
    end
  end

  context 'when switching users' do
    let(:current_user) do
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

    before { login_as other_user }

    it 'logs in' do
      expect(Current.user).to be(other_user)
    end
  end
end

RSpec.describe UMTS::Auth::RSpec, type: :request do
  context 'with no current user' do
    let(:current_user) { nil }

    it 'does not log in' do
      expect(response).to be_nil
    end
  end

  context 'with a current user' do
    let(:current_user) do
      User.create!(entra_uid: 'bobo-test',
                   entra_upn: 'bobo@test.com',
                   first_name: 'Bobo',
                   last_name: 'Test',
                   email: 'bobo@test.com')
    end

    it 'logs in' do
      expect(session[:entra_uid]).to eq(current_user.entra_uid)
    end
  end
end

RSpec.describe UMTS::Auth::RSpec, type: :system do
  let(:current_user) do
    User.create!(entra_uid: 'bobo-test',
                 entra_upn: 'bobo@test.com',
                 first_name: 'Bobo',
                 last_name: 'Test',
                 email: 'bobo@test.com')
  end

  before { visit root_path }

  it 'logs in' do
    expect(page).to have_text(current_user.name)
  end
end
