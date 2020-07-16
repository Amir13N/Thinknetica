# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'Post #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database with user parent' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to index view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to questions_path
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'Patch #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { body: 'new body', title: 'new title' }, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }

      it 'does not save a new question in the database' do
        question.reload

        expect(question.body).to eq 'QuestionText'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question, user: user) }

    let!(:other_question) { create(:question) }

    it 'deletes question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end

    it "can not delete other's question" do
      expect { delete :destroy, params: { id: other_question } }.to_not change(Question, :count)
    end
  end

  describe 'PATCH #delete_file' do
    before { login(user) }

    let(:question_with_file) { create(:question, :with_file, user: user) }
    let(:other_question_with_file) { create(:question, :with_file) }

    it 'deletes file' do
      patch :delete_file, params: { id: question_with_file, file_id: question_with_file.files.first, format: :js }
      question_with_file.reload

      expect(question_with_file.files).to_not be_attached
    end

    it "does not delete file attached to other user's question" do
      patch :delete_file, params: { id: other_question_with_file, file_id: other_question_with_file.files.first, format: :js }
      question_with_file.reload

      expect(other_question_with_file.files).to be_attached
    end
  end
end
