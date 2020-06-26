require 'rails_helper'

feature 'User can create question', %q{
  In order to get an answer from community
  As an authenticated user
  I'd like to be able to ask question
} do
  
  given(:user) { create(:user) }

  background {
      visit questions_path
      click_on 'Ask questions'
    }

  describe 'Authenticated user' do

    background { sign_in(user) }

    scenario 'asks question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text'
      click_on 'Ask'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text'
    end

    scenario 'asks a question with error' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

  end


  scenario 'Unauthenticated user tries to ask a question' do
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end