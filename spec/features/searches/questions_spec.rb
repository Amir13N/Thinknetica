require 'sphinx_helper'

feature 'User can search for questions', "
  In order to find needed questions
  As  an User
  I'd like to be able to search for questions
" do
  given!(:question) { create(:question, title: 'Title') }

  scenario 'User can search for question', sphinx: true, js: true do
    visit searches_question_path

    Thinking::Test.run do
      fill_in 'Search', with: 'title'
      click_on 'Search'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
