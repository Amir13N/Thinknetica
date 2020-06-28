# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answers', "
  If my answer is incorrect
  As an authenticated user
  I'd like to delete it
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }

  background { create_list(:answer, 3) }

  given!(:new_user) { create(:user) }

  describe 'Authenticated user' do
    scenario 'deletes his answer' do
      sign_in(user)
      visit questions_path
      click_on 'Show'
      first('#delete-link').click

      expect(page).to have_content 'Your answer was successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario "can not delete others' answers" do
      sign_in(new_user)
      visit questions_path
      click_on 'Show'

      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user tries to delete answers' do
    visit questions_path
    click_on 'Show'
    expect(page).to_not have_link 'Delete'
  end
end
