# frozen_string_literal: true

require 'rails_helper'

feature 'User can view question', "
  In order to find answers
  As an authenticated user
  I'd like to view questions
" do
  given!(:questions) { create_list(:question, 3) }

  scenario 'User views the list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'User views specific question' do
    visit questions_path
    first(:link, 'Show').click

    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.first.body
  end
end
