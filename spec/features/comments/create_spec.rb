# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer-comments', "
  In order to provide feedback to answer/question
  As an authenticated user
  I'd like to be able to create answer-comments
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment when asks question', js: true do
      within '.question-new-comment' do
        fill_in 'body', with: 'New comment'

        click_on 'Add comment'
      end

      within '.question-comments' do
        expect(page).to have_content 'New comment'
      end
    end

    scenario 'adds link when answers question', js: true do
      within '.answer-new-comment' do
        fill_in 'body', with: 'New comment'

        click_on 'Add comment'
      end

      within '.answer-comments' do
        expect(page).to have_content 'New comment'
      end
    end
  end

  context 'multiple sessions' do
    scenario "comment to question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question-new-comment' do
          fill_in 'body', with: 'New comment'

          click_on 'Add comment'
        end

        within '.question-comments' do
          expect(page).to have_content 'New comment'
        end
      end

      Capybara.using_session('guest') do
        within '.question-comments' do
          expect(page).to have_content 'New comment'
        end
      end
    end

    scenario "comment to answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answer-new-comment' do
          fill_in 'body', with: 'New comment'

          click_on 'Add comment'
        end

        within '.answer-comments' do
          expect(page).to have_content 'New comment'
        end
      end

      Capybara.using_session('guest') do
        within '.answer-comments' do
          expect(page).to have_content 'New comment'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to create comment' do
    visit question_path(question)

    expect(page).to_not have_content 'Add comment'
  end
end
