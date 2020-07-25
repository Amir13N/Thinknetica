# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get an answer from community
  As an authenticated user
  I'd like to be able to ask question
" do
  given(:user) { create(:user) }

  background do
    visit questions_path
    click_on 'Ask questions'
  end

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'asks question' do
      within '.main-form' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text'
    end

    scenario 'asks a question with error' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files' do
      within '.main-form' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      click_on 'Show'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
