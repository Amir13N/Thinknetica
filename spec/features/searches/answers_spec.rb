require 'sphinx_helper'

feature 'User can search for answers', "
  In order to find needed answers
  As  an User
  I'd like to be able to search for answers
" do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'User can search for answer', sphinx: true, js: true do
    visit question_path(question)

    ThinkingSphinx::Test.run do
      within '.answers-search' do
        fill_in 'search', with: answers.first.body
        click_on 'Search'
      end

      expect(page).to have_content answers.first.body
      expect(page).to_not have_content answers.last.body
    end
  end
end
