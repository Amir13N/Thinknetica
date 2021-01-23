# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit question', "
  In order to correct mistakes
  As an authenticated user
  I'd like to be able to edit question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_file, user: user) }
  given(:new_user) { create(:user) }

  background { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Edit'
    end

    scenario 'edits his question' do
      within '.questions' do
        fill_in 'title', with: 'edited question title'
        click_on 'Edit'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question title'
        expect(page).to_not have_selector 'textarea'
      end

      expect(page).to have_content 'Your question was successfully updated.'
    end

    scenario 'incorrectly edits question' do
      within '.questions' do
        fill_in 'title', with: ''
        click_on 'Edit'

        within "#edit-question-#{question.id}" do
          expect(page).to have_content "Title can't be blank"
        end
      end

      expect(page).to have_content 'Your question was not updated.'
    end

    scenario 'edits with attached files' do
      within '.questions' do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Edit'
      end

      within first('.question-files') do
        expect(page).to have_content 'rails_helper.rb'
        expect(page).to have_content 'spec_helper.rb'
      end
    end
  end

  scenario "Authenticated user tries to edit other's question" do
    sign_in(new_user)
    visit questions_path

    expect(page).to_not have_content 'Edit'
  end

  scenario 'Unauthenticated user tries to edit question' do
    visit questions_path

    expect(page).to_not have_content 'Edit'
  end
end
