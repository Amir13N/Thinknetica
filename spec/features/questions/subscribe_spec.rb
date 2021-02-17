# frozen_string_literal: true

require 'rails_helper'

feature 'User can subscribe to questions_path', "
  In order to get answer creation notifications
  As an authenticated user
  I'd like to be able to subscribe to question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }

    scenario 'can subscribe to question' do
      visit questions_path

      click_on 'Subscribe'

      within "#question-#{question.id}" do
        expect(page).to_not have_link 'Subscribe'
        expect(page).to have_content '#Subscribed'
        expect(page).to have_link 'Unsubscribe'
      end
    end

    scenario 'unsubscribes from question' do
      user.subscribes.push(question)
      visit questions_path

      click_on 'Unsubscribe'

      within "#question-#{question.id}" do
        expect(page).to have_link 'Subscribe'
        expect(page).to_not have_content '#Subscribed'
        expect(page).to_not have_link 'Unsubscribe'
      end
    end
  end

  scenario 'Unauthenticated user tries to subscribe to question', js: true do
    visit questions_path

    expect(page).to_not have_link 'Subscribe'
    expect(page).to_not have_content '#Subscribed'
    expect(page).to_not have_link 'Unsubscribe'
  end
end
