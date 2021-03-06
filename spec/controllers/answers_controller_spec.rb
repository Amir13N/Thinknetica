# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join 'spec/controllers/concerns/voted_spec.rb'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  it_behaves_like 'voted'

  before { create(:reward, question: question) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database with question parent' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer), format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'saves a new answer in the database with user parent' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer), format: :js }
        end.to change(user.answers, :count).by(1)
      end

      it 'renders create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        end.to_not change(Answer, :count)
      end
    end

    it 'renders create' do
      post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }

      expect(response).to render_template :create
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload

        expect(answer.body).to eq 'new body'
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update,
              params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid), format: :js }
      end

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
      expect do
        delete :destroy, params: { question_id: question, id: answer }, format: :js
      end.to change(Answer, :count).by(-1)
    end

    it 'renders destroy view' do
      delete :destroy, params: { question_id: question, id: answer }, format: :js
      expect(response).to render_template :destroy
    end

    it "can not delete other's answer" do
      expect do
        delete :destroy, params: { question_id: question, id: other_answer }, format: :js
      end.to_not change(Answer, :count)
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
end
