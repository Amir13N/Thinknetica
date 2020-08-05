# frozen_string_literal: true

require 'rails_helper'

feature 'User can create comments', "
  In order to provide feedback to answer/question
  As an authenticated user
  I'd like to be able to create comments
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'creates comment when asks question', js: true do
      visit question_path(question)

      within '.comment-create' do
        fill_in 'body', with: 'New comment'

        click_on 'Add comment'
      end

      within '.comments' do
        expect(page).to have_content 'New comment'
      end
    end

    scenario 'User adds link when answers question', js: true do
      visit answer_path(answer)

      within '.comment-create' do
        fill_in 'body', with: 'New comment'

        click_on 'Add comment'
      end

      within '.comments' do
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
        within '.comment-create' do
          fill_in 'body', with: 'New comment'

          click_on 'Add comment'
        end

        expect(page).to have_content 'New comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'New comment'
      end
    end

    scenario "comment to answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit answer_path(answer)
      end

      Capybara.using_session('guest') do
        visit answer_path(answer)
      end

      Capybara.using_session('user') do
        within '.comment-create' do
          fill_in 'body', with: 'New comment'

          click_on 'Add comment'
        end

        expect(page).to have_content 'New comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'New comment'
      end
    end
  end

  scenario 'Unauthenticated user tries to create comment' do
    visit question_path(question)

    expect(page).to_not have_content 'Add comment'
  end
end
