# frozen_string_literal: true

require 'rails_helper'

feature 'User can choose best answer for its question', "
  In order to save other users' time
  As an authenticated user
  I'd like to choose the best answer for my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question) }
  given!(:answer) { create(:answer, question: question, best: true) }
  given(:other_question) { create(:question) }

  background { create_list(:answer, 3, question: other_question) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'chooses the best answer for his question' do
      visit question_path(question)

      within first('.answer') do
        expect(page).to_not have_content 'Make the best'
      end

      first(:link, 'Make the best').click

      expect(page).to have_content 'Your answer was successfully chosen as the best'
      within "#answer-#{answers.first.id}" do
        expect(page).to_not have_content 'Make the best'
      end

      within first('.answer') do
        expect(page).to have_content answers.first.body
      end

      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Make the best'
      end
    end

    scenario "tries to choose the best answer for other's question" do
      visit question_path(other_question)

      expect(page).to_not have_content 'Make the best'
    end
  end

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(other_question)

    expect(page).to_not have_content 'Make the best'
  end
end
