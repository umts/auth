# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'application/development_login.html.haml' do
  subject(:call) { render template: 'application/development_login' }

  let(:user) { Struct.new(:entra_uid, :name).new('test-uid', 'Bobo Test') }

  before { allow(UMTS::Auth).to receive(:development_login_users).and_return(-> { { 'Users' => [user] } }) }

  it 'renders successfully' do
    call
    expect(rendered).to be_present
  end
end
