# frozen_string_literal: true

require 'rails_helper'

feature 'User can revote answer', "
  In order to change last vote
  As an authenticated user
  I'd like to revote answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:vote) { create(:vote, user: user, votable: answer) }

  scenario 'Authenticated user revotes answer' do
    sign_in(user)
    visit question_path(question)

    click_on 'Revote'
    within '.answer-rating' do
      expect(page).to have_content '0'
    end
  end

  scenario 'Unauthenticated user revotes answer' do
    visit question_path(question)
    expect(page).to have_content 'Revote'
  end
end
