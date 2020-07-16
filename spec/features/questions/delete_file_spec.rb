# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete files attached to question', "
  In order to free place
  As an authenticated user
  I'd like to be able to delete files
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_file, user: user) }
  given(:other_user) { create(:user) }

  describe 'Authenticated user', js: true do
    scenario 'deletes files attached to his question' do
      sign_in(user)
      visit questions_path

      within '.question-files' do
        click_on 'Delete'

        expect(page).to_not have_content 'rails_helper.rb'
      end
    end

    scenario "deletes files attached to other user's question" do
      sign_in(other_user)
      visit questions_path

      within '.question-files' do
        expect(page).to_not have_content 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete question files', js: true do
    visit questions_path

    within '.question-files' do
      expect(page).to_not have_content 'Delete'
    end
  end
end
