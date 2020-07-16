# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :title }

  it { should validate_uniqueness_of(:body).scoped_to(:title) }

  it { should belong_to :user }

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, best: true) }

  describe '#best_answer' do
    it 'returns best answer' do
      expect(question.best_answer).to eq answer
    end
  end

  it 'has many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
