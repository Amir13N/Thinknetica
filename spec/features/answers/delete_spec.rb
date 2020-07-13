# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answer', "
  If my answer is incorrect
  As an authenticated user
  I'd like to delete it
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background { create_list(:answer, 3, question: question) }

  given!(:new_user) { create(:user) }

  scenario 'Authenticated user deletes his answer', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content answer.body

    first(:link, 'Delete').click

    expect(page).to have_content 'Your answer was successfully deleted.'
    within '.answers' do
      expect(page).to_not have_content answer.body
    end
  end

  scenario "Authenticated user can not delete others' answers" do
    sign_in(new_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'Unauthenticated user tries to delete answers' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end
end
