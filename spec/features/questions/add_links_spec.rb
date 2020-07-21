# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://test.com' }

  background { create(:question, user: user) }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    within '.main-form' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    fill_in 'Link name', with: 'My gist1'
    fill_in 'Url', with: gist_url

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My gist2'
      fill_in 'Url', with: gist_url
    end

    first(:link, 'Remove link').click

    click_on 'Ask'

    expect(page).to have_link 'My gist2', href: gist_url
    expect(page).to_not have_link 'My gist1', href: gist_url
  end

  scenario 'User adds link when edits question', js: true do
    sign_in(user)
    visit questions_path

    within '.questions' do
      click_on 'Edit'

      fill_in 'title', with: 'New title'
      fill_in 'body', with: 'New question'

      click_on 'Add link'

      fill_in 'Link name', with: 'My new gist'
      fill_in 'Url', with: gist_url

      click_on 'Edit'

      expect(page).to have_link 'My new gist', href: gist_url
    end
  end
end
