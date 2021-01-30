# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
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
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_json[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/id' do
    let(:question) { create(:question, :with_file) }
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

      # describe 'files' do
      #   let(:file) { question.file }
      #   let(:file_json) { question_json['files'].first }

      #   it 'returns list of files' do
      #     expect(question_json['files'].size).to eq 2
      #   end

      #   it 'returns all public fields' do
      #     %w[id attachable_id created_at updated_at].each do |attr|
      #       expect(file_json[attr]).to eq file.send(attr).as_json
      #     end
      #   end
      # end

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
end
