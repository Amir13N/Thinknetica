# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit answer', "
  In order to correct mistakes
  As an authenticated user
  I'd like to be able to edit answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given(:new_user) { create(:user) }

  background { create(:answer) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'edits his answer' do
      within '.answers' do
        fill_in 'body', with: 'edited answer'
        click_on 'Edit'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end

      expect(page).to have_content 'Your answer was successfully updated.'
    end

    scenario 'incorrectly edits answer' do
      within '.answers' do
        fill_in 'body', with: ''
        click_on 'Edit'

        within "#edit-answer-#{answer.id}" do
          expect(page).to have_content "Body can't be blank"
        end
      end

      expect(page).to have_content 'Your answer was not updated.'
    end
  end

  scenario "Authenticated user tries to edit other's answer" do
    sign_in(new_user)
    visit question_path(question)

    expect(page).to_not have_content 'Edit'
  end

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Edit'
  end
end
