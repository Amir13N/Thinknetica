# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  before { create(:reward, question: question) }

  describe 'Post #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database with question parent' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'saves a new answer in the database with user parent' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(user.answers, :count).by(1)
      end

      it 'renders create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(Answer, :count)
      end
    end

    it 'renders create' do
      post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }

      expect(response).to render_template :create
    end
  end

  describe 'Patch #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload

        expect(answer.body).to eq 'new body'
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid), format: :js } }

      it 'does not save a new answer in the database' do
        answer.reload

        expect(answer.body).to match 'AnswerText'
      end
    end

    it 'renders update view' do
      patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:other_answer) { create(:answer) }

    it 'deletes answer' do
      expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'renders destroy view' do
      delete :destroy, params: { question_id: question, id: answer }, format: :js
      expect(response).to render_template :destroy
    end

    it "can not delete other's answer" do
      expect { delete :destroy, params: { question_id: question, id: other_answer }, format: :js }.to_not change(Answer, :count)
    end
  end

  describe 'PATCH #choose_best' do
    before { login(user) }

    let(:other_question_answer) { create(:answer) }
    let(:other_answer) { create(:answer, question: question) }

    it "changes 'best' attribute value of an answer" do
      patch :choose_best, params: { id: answer }, format: :js
      answer.reload

      expect(answer.best).to be_truthy
    end

    it "does not work with answer of other user's question" do
      patch :choose_best, params: { id: other_question_answer }, format: :js
      other_answer.reload

      expect(other_answer.best).to be_falsey
    end

    it "awards answer's author" do
      patch :choose_best, params: { id: other_answer }, format: :js

      expect(other_answer.user.rewards.include?(question.reward)).to be_truthy
    end
  end

  describe 'PATCH #vote_for' do
    before { login(user) }

    let!(:answer) { create(:answer) }
    let!(:user_answer) { create(:answer, user: user) }

    it 'adds positive vote to answer' do
      expect { patch :vote_for, params: { id: answer, format: :json } }.to change(answer.votes.where(positive: true), :count).by(1)
    end

    it "can not add vote to authenticated user's answer" do
      expect { patch :vote_for, params: { id: user_answer, format: :js } }.to_not change(answer.votes.where(positive: true), :count)
    end
  end

  describe 'PATCH #vote_against' do
    before { login(user) }

    let!(:answer) { create(:answer) }
    let!(:user_answer) { create(:answer, user: user) }

    it 'adds positive vote to answer' do
      expect { patch :vote_against, params: { id: answer, format: :json } }.to change(answer.votes.where(positive: false), :count).by(1)
    end

    it "can not add vote to authenticated user's answer" do
      expect { patch :vote_against, params: { id: user_answer, format: :js } }.to_not change(answer.votes.where(positive: false), :count)
    end
  end

  describe 'PATCH #revote' do
    before { login(user) }

    let!(:answer) { create(:answer) }
    let!(:user_answer) { create(:answer, user: user) }
    before do
      create(:vote, votable: answer, user: user)
      create(:vote, votable: user_answer, user: user)
    end

    it 'removes vote to answer' do
      expect { delete :revote, params: { id: answer, format: :json } }.to change(answer.votes, :count).by(-1)
    end

    it "can not remove vote of authenticated user's answer" do
      expect { delete :revote, params: { id: user_answer, format: :js } }.to_not change(answer.votes, :count)
    end
  end
end
