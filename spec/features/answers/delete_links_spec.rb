# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete links attached to answer', "
  In order to free place
  As an authenticated user
  I'd like to be able to delete links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable: answer) }
  given(:other_user) { create(:user) }

  describe 'Authenticated user', js: true do
    scenario 'deletes links attached to his answer' do
      sign_in(user)
      visit question_path(question)

      within '.answer-links' do
        click_on 'Delete'

        expect(page).to_not have_content link.name
      end
    end

    scenario "deletes links attached to other user's answer" do
      sign_in(other_user)
      visit question_path(question)

      within '.answer-links' do
        expect(page).to_not have_content 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete answer links', js: true do
    visit question_path(question)

    within '.answer-links' do
      expect(page).to_not have_content 'Delete'
    end
  end
end
