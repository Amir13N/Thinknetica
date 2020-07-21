# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for/against answer', "
  In order to rate answers
  As an authenticated user
  I'd like to vote for/against answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:other_user_answer) { create(:answer, question: question) }
  given!(:user_answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes for other user answers' do
      click_on 'Vote for'

      within "#answer-rating-#{other_user_answer.id}" do
        expect(page).to have_content '1'
      end
    end

    scenario 'votes for his answer' do
      within "#answer-rating-#{user_answer.id}" do
        expect(page).to_not have_content 'Vote for'
      end
    end

    scenario 'votes against other user answer' do
      click_on 'Vote against'

      within "#answer-rating-#{other_user_answer.id}" do
        expect(page).to have_content '-1'
      end
    end

    scenario 'votes against his answer' do
      within "#answer-rating-#{user_answer.id}" do
        expect(page).to_not have_content 'Vote against'
      end
    end
  end

  scenario 'Unauthenticated user votes for/against answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Vote'
  end
end
