# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

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

    let(:other_answer) { create(:answer) }

    it "changes 'best' attribute value of an answer" do
      patch :choose_best, params: { id: answer }, format: :js
      answer.reload

      expect(answer.best).to be_truthy
    end

    it "does not work with answer of other user's question" do
      patch :choose_best, params: { id: other_answer }, format: :js
      other_answer.reload

      expect(other_answer.best).to be_falsey
    end
  end

  describe 'PATCH #delete_file' do
    before { login(user) }

    let(:answer_with_file) { create(:answer, :with_file, user: user) }
    let(:other_answer_with_file) { create(:answer, :with_file) }

    it 'deletes file' do
      patch :delete_file, params: { id: answer_with_file, file_id: answer_with_file.files.first, format: :js }
      answer_with_file.reload

      expect(answer_with_file.files).to_not be_attached
    end

    it "does not delete file attached to other user's answer" do
      patch :delete_file, params: { id: other_answer_with_file, file_id: other_answer_with_file.files.first, format: :js }
      answer_with_file.reload

      expect(other_answer_with_file.files).to be_attached
    end
  end
end
