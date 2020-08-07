# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to help community
  As an authenticated user
  I'd like to be able to answer questions
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'gives valid answer to question' do
      within '.new-answer' do
        fill_in 'body', with: 'answer'
      end
      click_on 'Answer'

      expect(page).to have_content 'Your answer was successfully created.'
      within '.answers' do
        expect(page).to have_content 'answer'
      end
    end

    scenario 'gives invalid answer to question' do
      click_on 'Answer'

      expect(page).to have_content 'Your answer was not created.'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers a question with attached files' do
      within '.new-answer' do
        fill_in 'body', with: 'answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      end
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-answer' do
          fill_in 'body', with: 'answer'
        end
        click_on 'Answer'

        expect(page).to have_content 'answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'answer'
      end
    end
  end

  scenario 'Unauthenticated user tries to answer question' do
    visit question_path(question)
    expect(page).to_not have_content 'Answer question'
  end
end
