# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'Post #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        user_answer_count = user.answers.count
        question_answer_count = question.answers.count
        answer_count = Answer.count
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(Answer.count).to eq answer_count + 1
        expect(question.answers.count).to eq question_answer_count + 1
        expect(user.answers.count).to eq user_answer_count + 1
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end
    end

    it 'renders question show view' do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }

      expect(response).to render_template(partial: 'questions/show', locals: { question: question })
    end
  end

  describe 'Patch #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated answer' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not save a new answer in the database' do
        answer.reload

        expect(answer.body).to eq 'AnswerText'
      end

      it 're-renders new view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question) }
    let!(:answer) { create(:answer) }

    it 'deletes answer' do
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { question_id: question, id: answer }
      expect(response).to redirect_to question
    end
  end
end
