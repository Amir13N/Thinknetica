require 'rails_helper'

feature 'User can delete files attached to answer', "
  In order to free place
  As an authenticated user
  I'd like to be able to delete files
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_file, question: question, user: user) }
  given(:other_user) { create(:user) }

  describe 'Authenticated user', js: true do
    scenario 'deletes files attached to his answer' do
      sign_in(user)
      visit question_path(question)

      within '.answer-files' do
        click_on 'Delete'

        expect(page).to_not have_content 'rails_helper.rb'
      end
    end

    scenario "deletes files attached to other user's answer" do
      sign_in(other_user)
      visit question_path(question)

      within '.answer-files' do
        expect(page).to_not have_content 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete answer files', js: true do
    visit question_path(question)
    
    within '.answer-files' do
      expect(page).to_not have_content 'Delete'
    end
  end
end
