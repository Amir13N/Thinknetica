# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'votable' do
  describe '#vote_for' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'creates new vote for question' do
      expect { question.vote_for(user) }.to change(question.votes, :count).by(1)
    end

    it 'creates new vote with rate 1' do
      question.vote_for(user)

      expect(question.votes.last.rate).to be_truthy
    end
  end

  describe '#vote_against' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'creates new vote for question' do
      expect { question.vote_against(user) }.to change(question.votes, :count).by(1)
    end

    it 'creates new vote with rate -1' do
      question.vote_against(user)

      expect(question.votes.pluck(:rate).include?(-1)).to be_truthy 
    end
  end

  describe '#revote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before { question.vote_for(user) }

    it 'destroys vote' do
      expect { question.revote(user) }.to change(question.votes, :count).by(-1)
    end
  end

  describe '#voted?' do
    let(:voted_user) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before { question.vote_for(voted_user) }

    it 'returns true' do
      expect(question.voted?(voted_user)).to be_truthy
    end

    it 'returns false' do
      expect(question.voted?(user)).to be_falsey
    end
  end
end
