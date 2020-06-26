require 'rails_helper'

feature 'User can delete questions', %q{
  In order to free space for questions
  As an authenticated user
  I'd like to delete questions
} do

  given!(:user) { create(:user) }

  describe 'Authenticated user' do

    scenario 'deletes all his questions' do
      sign_in(user)
      question = create(:question)
      visit questions_path
      click_on 'Delete'

      expect(page).to have_content 'Your question was successfully deleted.'
      expect(page).to_not have_content question.body
      expect(page).to_not have_content question.title
    end

    scenario "deletes others' questions" do
      create_list(:question, 3)
      new_user = create(:user)
      sign_in(new_user)
      visit questions_path

      expect(page).to_not have_content 'Delete'    
    end

  end

  scenario 'Unauthenticated user can not delete questions' do
    visit questions_path
    expect(page).to_not have_content 'Delete'
  end
end