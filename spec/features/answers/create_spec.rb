# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to help community
  As an authenticated user
  I'd like to be able to answer questions
" do
  given!(:user) { create(:user) }

  background { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    visit questions_path
    click_on 'Show'
    end

    scenario 'gives valid answer question' do
      fill_in 'Body', with: 'answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer was successfully created.'
      expect(page).to have_content 'answer'
    end

    scenario 'gives invalid answer to question' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer question' do
    visit questions_path
    click_on 'Show'
    expect(page).to_not have_content 'Answer question'
  end
end
