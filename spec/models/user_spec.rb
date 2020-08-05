# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: user) }
    let(:other_answer) { create(:answer) }

    it 'returns true' do
      expect(user).to be_author_of(answer)
    end

    it 'returns false' do
      expect(user).to_not be_author_of(other_answer)
    end
  end
end
