# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete links attached to question', "
  In order to free place
  As an authenticated user
  I'd like to be able to delete links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }
  given(:other_user) { create(:user) }

  describe 'Authenticated user', js: true do
    scenario 'deletes links attached to his question' do
      sign_in(user)
      visit questions_path

      within '.question-links' do
        click_on 'Delete'

        expect(page).to_not have_content link.name
      end
    end

    scenario "deletes links attached to other user's question" do
      sign_in(other_user)
      visit questions_path

      within '.question-links' do
        expect(page).to_not have_content 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete question links', js: true do
    visit questions_path

    within '.question-links' do
      expect(page).to_not have_content 'Delete'
    end
  end
end
