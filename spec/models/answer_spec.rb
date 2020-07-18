# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :links }

  let(:question) { create(:question) }
  let!(:best_answer) { create(:answer, question: question, best: true) }
  let(:answer) { create(:answer, question: question) }

  describe '#best_answer_presence' do
    it 'returns false' do
      expect(answer.update(best: true)).to be_falsey
    end

    it 'returns true' do
      question.best_answer.update(best: false)

      expect(answer.update(best: true)).to be_truthy
    end
  end

  describe '#make_best' do
    before do
      answer.make_best
      best_answer.reload
    end

    it 'changes best attribute of an answer to false' do
      expect(best_answer.best).to be_falsey
    end

    it 'changes best attribute of answer to true' do
      expect(answer.best).to be_truthy
    end
  end

  it 'has many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
