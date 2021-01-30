# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  let(:service) { double('FindForOauthService') }

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#github' do
    let(:oauth_data) { { provider: 'github', uid: 123 } }

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    end

    it 'finds user from oauth data' do
      expect(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
      expect(service).to receive(:call)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
        allow(service).to receive(:call).and_return(user)
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
        allow(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
        allow(service).to receive(:call)
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
      allow(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
      allow(service).to receive(:call)
      get :vkontakte
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        allow(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
        allow(service).to receive(:call).and_return(user)
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
      context 'provider gives email' do
        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          allow(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
          allow(service).to receive(:call)
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
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_invalid)
          allow(FindForOauthService).to receive(:new).with(oauth_data_invalid).and_return(service)
          allow(service).to receive(:call)
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

  describe 'POST #send_email_confirmation_message' do
    it 'sends message' do
      session[:auth] = { provider: 'vkontakte', uid: 123 }
      expect(FindForOauthService).to receive(:new).and_return(service)
      expect(service).to receive(:call)
      post :send_email_confirmation_message
    end
  end
end
