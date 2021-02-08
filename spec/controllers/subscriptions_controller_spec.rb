require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    let!(:question) { create(:question) }

    it 'create subscription' do
      login(user)
      expect { post :create, params: { question_id: question.id } }.to change(user.subscribes, :count).by(1)
    end

    it 'can not create subscription if user not authenticated' do
      expect { post :create, params: { question_id: question.id } }.to_not change(user.subscribes, :count)
    end

    it 'can not create subscription if already subscribed' do
      login(user)
      question.subscribers.push(user)
      expect { post :create, params: { question_id: question.id } }.to_not change(user.subscribes, :count)
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question) }

    it 'adds question to user subscribes' do
      user.subscribes.push(question)
      expect do
        delete :destroy, params: { question_id: question.id }
      end.to change(user.subscribes, :count).by(-1)
    end

    it 'can not add question to user subscribes' do
      expect do
        delete :destroy, params: { question_id: question.id }
      end.to_not change(user.subscribes, :count)
    end
  end
end
