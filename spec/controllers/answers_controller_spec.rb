# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question) }

  describe 'Post #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database with question parent' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'saves a new answer in the database with user parent' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(user.answers, :count).by(1)
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

        expect(answer.body).to match 'AnswerText'
      end

      it 're-renders new view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let(:question) { create(:question) }
    let!(:answer) { create(:answer, user: user, question: question) }

    let!(:other_answer) { create(:answer) }

    it 'deletes answer' do
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { question_id: question, id: answer }
      expect(response).to redirect_to question
    end

    it "can not to delete other's answer" do
      expect { delete :destroy, params: { question_id: question, id: other_answer } }.to_not change(Answer, :count)
    end
  end
end
