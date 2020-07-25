# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for/against question', "
  In order to rate questions
  As an authenticated user
  I'd like to vote for/against question
" do
  given(:user) { create(:user) }
  given!(:other_user_question) { create(:question) }
  given!(:user_question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'votes for other user questions' do
      click_on 'Vote for'

      within "#question-rating-#{other_user_question.id}" do
        expect(page).to have_content '1'
      end
    end

    scenario 'votes for his question' do
      within "#question-rating-#{user_question.id}" do
        expect(page).to_not have_content 'Vote for'
      end
    end

    scenario 'votes against other user question' do
      click_on 'Vote against'

      within "#question-rating-#{other_user_question.id}" do
        expect(page).to have_content '-1'
      end
    end

    scenario 'votes against his question' do
      within "#question-rating-#{user_question.id}" do
        expect(page).to_not have_content 'Vote against'
      end
    end
  end

  scenario 'Unauthenticated user votes for/against question' do
    visit questions_path
    expect(page).to_not have_content 'Vote'
  end
end
