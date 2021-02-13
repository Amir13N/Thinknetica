require 'sphinx_helper'

feature 'User can search for questions', "
  In order to find needed questions
  As  an User
  I'd like to be able to search for questions
" do
  given!(:questions) { create_list(:question, 2) }

  scenario 'User can search for question', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in 'search', with: questions.first.title
      click_on 'Search'

      expect(page).to have_content questions.first.title
      expect(page).to_not have_content questions.last.title
    end
  end
end
