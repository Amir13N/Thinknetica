require 'sphinx_helper'

feature 'User can search for any resource', "
  In order to find needed resource
  As  an User
  I'd like to be able to search through all resources
" do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }

  scenario 'User can search for any resource', sphinx: true, js: true do
    visit searches_path

    ThinkingSphinx::Test.run do
      fill_in 'search', with: question.title
      click_on 'Search'

      expect(page).to have_content question.title
      expect(page).to_not have_content answer.body
    end
  end
end
