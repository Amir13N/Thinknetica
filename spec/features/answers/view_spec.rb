# frozen_string_literal: true

require 'rails_helper'

feature 'User can view answer', "
  In order to get help
  As an authenticated user
  I'd like to view answers
" do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User views the list of answers' do
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
