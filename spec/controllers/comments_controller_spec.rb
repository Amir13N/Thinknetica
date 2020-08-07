# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment in the database with question parent' do
        expect { post :create, params: { commentable_id: question, comment: attributes_for(:comment), commentable: 'questions', format: :js } }.to change(question.comments, :count).by(1)
      end

      it 'saves a new comment in the database with user parent' do
        expect { post :create, params: { commentable_id: question, comment: attributes_for(:comment), commentable: 'questions', format: :js } }.to change(user.comments, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new comment in the database' do
        expect { post :create, params: { commentable_id: question, comment: attributes_for(:comment, :invalid), commentable: 'questions', format: :js } }.to_not change(Comment, :count)
      end
    end
  end
end
