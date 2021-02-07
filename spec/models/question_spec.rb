# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join 'spec/models/concerns/votable_spec.rb'

RSpec.describe Question, type: :model do
  it { have_many_and_belong_to :subscribers }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :title }

  it { should validate_uniqueness_of(:body).scoped_to(:title) }

  it { should belong_to :user }

  it { should accept_nested_attributes_for :links }

  it_behaves_like 'votable'

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, best: true) }
  let(:user) { create(:user) }

  describe '#best_answer' do
    it 'returns best answer' do
      expect(question.best_answer).to eq answer
    end
  end

  it 'has many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#subscribed?' do
    it 'returns false if user is not subscribed to question' do
      expect(question.subscribed?(user)).to be_falsey
    end

    it 'returns true if user is subscribed to question' do
      question.subscribers.push(user)
      expect(question.subscribed?(user)).to be_truthy
    end
  end

  describe '#subscribe_author' do
    let(:new_question) { create(:question, user: user) }

    it 'adds author to subscribers' do
      expect(user.subscribes).to include new_question
    end
  end
end
