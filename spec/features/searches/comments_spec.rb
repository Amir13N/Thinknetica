require 'sphinx_helper'

feature 'User can search for comments', "
  In order to find needed comments
  As  an User
  I'd like to be able to search for comments
" do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:question_comments) { create_list(:comment, 2, commentable: question) }
  given!(:answer_comments) { create_list(:comment, 2, commentable: answer) }

  scenario 'User can search for question comments', sphinx: true, js: true do
    visit question_path(question)

    ThinkingSphinx::Test.run do
      within '.question-comments-search' do
        fill_in 'search', with: question_comments.first.body
        click_on 'Search'
      end

      expect(page).to have_content question_comments.first.body
      expect(page).to_not have_content question_comments.last.body
    end
  end

  scenario 'User can search for answer comments', sphinx: true, js: true do
    visit question_path(question)

    ThinkingSphinx::Test.run do
      within '.answer-comments-search' do
        fill_in 'search', with: answer_comments.first.body
        click_on 'Search'
      end

      expect(page).to have_content answer_comments.first.body
      expect(page).to_not have_content answer_comments.last.body
    end
  end
end
