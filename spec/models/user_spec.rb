# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }

  it { should have_many(:answers).dependent(:destroy) }

  describe '#author_of?' do
    let(:user) { create(:user) }

    it 'returns true' do
      answer = create(:answer, user: user)

      expect(user.author_of?(answer)).to be_truthy
    end

    it 'returns false' do
      answer =  create(:answer)

      expect(user.author_of?(answer)).to be_falsey
    end
  end
end
