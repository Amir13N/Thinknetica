require 'rails_helper'

feature 'User can view questions', %q{
  In order to find answers
  As an authenticated user
  I'd like to view questions
} do

  background { create(:user) }

  scenario 'User views the list of questions' do
    questions = create_list(:question, 3)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'User views specific question and its answers' do
    question = create(:question)
    answers = create_list(:answer, 3)
    visit questions_path
    click_on 'Show'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end