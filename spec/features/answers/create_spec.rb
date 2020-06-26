require 'rails_helper'

feature 'User can create answer', %q{
  In order to help community
  As an authenticated user
  I'd like to be able to answer questions
} do
  
  given!(:user) { create(:user) }

  background { create(:question) }

  describe 'Authenticated user' do

    background { 
      sign_in(user)
      show_question
    }

    scenario 'gives valid answer question' do
      fill_in 'Body', with: 'answer'
      check 'Correct'
      click_on 'Answer'

      expect(page).to have_content 'Your answer was successfully created.'
      expect(page).to have_content 'answer'
      expect(page).to have_content 'true'
    end

    scenario 'gives invalid answer to question' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

  end


  scenario 'Unauthenticated user tries to answer question' do
    show_question
    expect(page).to_not have_content 'Answer question'
  end

end