# frozen_string_literal: true

require 'rails_helper'

feature 'User can view answers', "
  In order to get help
  As an authenticated user
  I'd like to view answers
" do
  background { create(:user) }

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3) }

  scenario 'User views the list of answers' do
    visit questions_path
    click_on 'Show'

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
