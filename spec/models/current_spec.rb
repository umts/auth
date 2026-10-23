# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Current do
  describe '#user=' do
    subject(:call) { described_class.user = user }

    let(:user) { create(:user) }

    after { described_class.reset }

    context 'without paper trail' do
      before { hide_const('PaperTrail') }

      it 'does not error out' do
        expect { call }.not_to raise_error
      end
    end

    context 'with paper trail' do
      it 'sets the paper trail whodunnit' do
        call
        expect(PaperTrail.request.whodunnit).to eq(user.id)
      end
    end
  end

  describe '#reset' do
    subject(:call) { described_class.reset }

    before { described_class.user = create(:user) }

    context 'without paper trail' do
      before { hide_const('PaperTrail') }

      it 'does not error out' do
        expect { call }.not_to raise_error
      end
    end

    context 'with paper trail' do
      it 'clears the paper trail whodunnit' do
        call
        expect(PaperTrail.request.whodunnit).to be_nil
      end
    end
  end
end
