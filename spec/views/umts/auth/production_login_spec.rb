# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'umts/auth/production_login.html.haml' do
  subject(:call) { render template: 'umts/auth/production_login' }

  it 'renders successfully' do
    call
    expect(rendered).to be_present
  end
end
