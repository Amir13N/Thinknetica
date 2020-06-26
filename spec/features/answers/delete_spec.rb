require 'rails_helper'

feature 'User can delete answers', %q{
  If my answer is incorrect
  As an authenticated user
  I'd like to delete it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do

    scenario 'deletes his answer' do
      answer = create(:answer)
      sign_in(user)
      show_question
      click_on 'Delete'

      expect(page).to have_content 'Your answer was successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario "can not delete others' answers" do
      create_list(:answer, 3)
      new_user = create(:user)
      sign_in(new_user)
      show_question

      expect(page).to_not have_content 'Delete'
    end

  end

  scenario 'Unauthenticated user tries to delete answers' do
    show_question
    expect(page).to_not have_content 'Delete'
  end
end