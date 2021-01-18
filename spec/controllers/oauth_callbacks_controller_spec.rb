# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#github' do
    let(:oauth_data) { { provider: 'github', uid: 123 } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user if it does not exist' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe '#vkontakte' do
    let(:oauth_data) { { provider: 'vkontakte', uid: 123, info: { email: 'test@mail.ru' } } }

    it 'finds user from oauth data with email' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before { allow(request.env).to receive(:[]).and_call_original }

      context 'provider gives email' do
        before do
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          allow(User).to receive(:find_for_oauth)
          get :vkontakte
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end

        it 'does not login user if it does not exist' do
          expect(subject.current_user).to_not be
        end
      end

      context 'provider does not give email' do
        let(:oauth_data_invalid) { { provider: 'vkontakte', uid: 123, info: { email: nil } } }

        before do
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_invalid)
          allow(User).to receive(:find_for_oauth)
          get :vkontakte
        end

        it 'redirects to email confirmation path' do
          expect(response).to redirect_to email_confirmation_path
        end

        it 'does not login user if it does not exist' do
          expect(subject.current_user).to_not be
        end
      end
    end
  end
end
