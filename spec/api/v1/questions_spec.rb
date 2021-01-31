# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_json) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns user id' do
        expect(question_json['user']['id']).to eq question.user_id
      end

      it 'returns short title' do
        expect(question_json['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_json) { question_json['answers'].first }

        it 'returns list of answers' do
          expect(question_json['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_json[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_json) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_json) { question_json['comments'].first }

        it 'returns list of comments' do
          expect(question_json['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body commentable_id created_at updated_at].each do |attr|
            expect(comment_json[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_json) { question_json['links'].first }

        it 'returns list of comments' do
          expect(question_json['links'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id name url linkable_id created_at updated_at].each do |attr|
            expect(link_json[attr]).to eq link.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/id' do
    let!(:access_token) { create(:access_token) }
    let(:answer) { create(:answer, user: User.last) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context "user's answer" do
        before do
          patch api_path, params: { access_token: access_token.token, answer: { body: 'new body' } }, headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'updates answer' do
          answer.reload
          expect(answer.body).to eq 'new body'
        end
      end

      context "other user's answer" do
        let(:other_answer) { create(:answer) }
        let(:wrong_api_path) { "/api/v1/answers/#{other_answer.id}" }
        before do
          patch wrong_api_path, params: { access_token: access_token.token, answer: { body: 'new body' } },
                                headers: headers
        end

        it 'does not update other user answer' do
          expect(other_answer.body).to_not eq 'new body'
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/id' do
    let!(:access_token) { create(:access_token) }
    let(:question) { create(:question, user: User.last) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context "user's question" do
        let!(:question) { create(:question, user: User.last) }

        it 'deletes question' do
          expect do
            delete api_path, params: { access_token: access_token.token }, headers: headers
          end.to change(Question, :count).by(-1)
        end
      end

      context "other user's question" do
        let!(:other_question) { create(:question) }
        let(:wrong_api_path) { "/api/v1/questions/#{other_question.id}" }

        it 'does not delete other user question' do
          expect do
            delete wrong_api_path, params: { access_token: access_token.token }, headers: headers
          end.to_not change(Answer, :count)
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'create question' do
        expect do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question) },
                         headers: headers
        end.to change(Question, :count).by(1)
      end
    end
  end
end
