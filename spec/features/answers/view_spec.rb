require 'rails_helper'

feature 'User can view answers', %q{
  In order to get help
  As an authenticated user
  I'd like to view answers
} do

  background { 
    create(:user)
  }

  given!(:question) { create(:question) }

  scenario 'User views the list of answers' do
    answers = create_list(:answer, 3)
    show_question

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end