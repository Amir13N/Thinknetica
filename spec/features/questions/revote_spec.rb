# frozen_string_literal: true

require 'rails_helper'

feature 'User can revote question', "
  In order to change last vote
  As an authenticated user
  I'd like to revote question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  background { create(:vote, user: user, votable: question) }

  scenario 'Authenticated user revotes question', js: true do
    sign_in(user)
    visit questions_path

    click_on 'Revote'
    within '.question-rating' do
      expect(page).to have_content '0'
    end
  end

  scenario 'Unauthenticated user revotes question' do
    visit questions_path
    expect(page).to_not have_content 'Revote'
  end
end
