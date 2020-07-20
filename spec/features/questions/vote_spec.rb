require 'rails_helper'

feature 'User can vote for/against question', "
  In order to rate questions
  As an authenticated user
  I'd like to vote for/against question
" do
  given(:user){ create(:user) }

  background { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'votes for questions' do
      click_on 'Vote for'

      within '.question-rating' do
       expect(page).to have_content '1'
      end
    end
  end
end