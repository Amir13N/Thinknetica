# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  let(:question) { create(:question) }

  before { create(:answer, question: question, best: true) }

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
end
