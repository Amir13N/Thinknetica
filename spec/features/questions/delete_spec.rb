# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete questions', "
  In order to free space for questions
  As an authenticated user
  I'd like to delete questions
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  background { create_list(:question, 3) }

  given(:new_user) { create(:user) }

  describe 'Authenticated user' do
    scenario 'deletes all his questions' do
      sign_in(user)
      visit questions_path
      first('#delete-link').click

      expect(page).to have_content 'Your question was successfully deleted.'
      expect(page).to_not have_content question.title + question.body
    end

    scenario "deletes others' questions" do
      sign_in(new_user)
      visit questions_path

      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Unauthenticated user tries to delete questions' do
    visit questions_path
    expect(page).to_not have_content 'Delete'
  end
end