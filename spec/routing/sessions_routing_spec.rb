# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Session routing' do
  it 'routes GET /auth/:provider/callback to the sessions create action' do
    expect(get: '/auth/entra_id/callback').to route_to(controller: 'sessions', action: 'create', provider: 'entra_id')
  end

  it 'routes POST /logout to the sessions destroy action' do
    expect(post: '/logout').to route_to(controller: 'sessions', action: 'destroy')
  end

  it 'directs entra_login_path to omniauth' do
    expect(entra_login_path).to eq('/auth/entra_id')
  end
end
