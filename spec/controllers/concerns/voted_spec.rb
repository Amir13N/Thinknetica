# frozen_string_literal: true

require 'rails_helper'

shared_examples 'voted' do
  describe 'PATCH #vote_for' do
    let(:new_user) { create(:user) }
    let(:user_answer) { create(:answer, user: user) }

    it 'creates new vote for answer' do
      login(new_user)

      expect { patch :vote_for, params: { id: answer, format: :json } }.to change(answer.votes, :count).by(1)
    end

    it "can not add vote to authenticated user's answer" do
      login(user)

      expect { patch :vote_for, params: { id: user_answer, format: :json } }.to_not change(answer.votes, :count)
    end

    it 'can not be applied by unauthenticated user' do
      expect { patch :vote_for, params: { id: answer, format: :json } }.to_not change(answer.votes, :count)
    end
  end

  describe 'PATCH #vote_against' do
    let(:new_user) { create(:user) }
    let(:user_answer) { create(:answer, user: user) }

    it 'creates new vote for answer' do
      login(new_user)

      expect { patch :vote_against, params: { id: answer, format: :json } }.to change(answer.votes, :count).by(1)
    end

    it "can not add vote to authenticated user's answer" do
      login(user)

      expect { patch :vote_against, params: { id: user_answer, format: :json } }.to_not change(answer.votes, :count)
    end

    it 'can not be applied by unauthenticated user' do
      expect { patch :vote_against, params: { id: answer, format: :json } }.to_not change(answer.votes, :count)
    end
  end

  describe 'DELETE #revote' do
    let(:new_user) { create(:user) }
    let(:user_answer) { create(:answer, user: user) }

    before { answer.vote_for(new_user) }

    it 'deletes vote from answer' do
      login(new_user)

      expect { delete :revote, params: { id: answer, format: :json } }.to change(answer.votes, :count).by(-1)
    end

    it "can not delete vote from authenticated user's answer" do
      login(user)

      expect { delete :revote, params: { id: user_answer, format: :json } }.to_not change(answer.votes, :count)
    end

    it 'can not be applied by unauthenticated user' do
      expect { delete :revote, params: { id: answer, format: :json } }.to_not change(answer.votes, :count)
    end
  end
end
