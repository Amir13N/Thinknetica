# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://test.com' }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'User adds link when answers question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'body', with: 'Answer'
    end

    click_on 'Add link'

    fill_in 'Link name', with: 'My gist1'
    fill_in 'Url', with: gist_url

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My gist2'
      fill_in 'Url', with: gist_url
    end

    first(:link, 'Remove link').click

    click_on 'Answer'

    expect(page).to have_link 'My gist2', href: gist_url
    expect(page).to_not have_link 'My gist1', href: gist_url
  end

  scenario 'User adds link when edits answer', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id}" do
      click_on 'Edit'

      within '.edit-answer' do
        fill_in 'body', with: 'New Answer'

        click_on 'Add link'

        fill_in 'Link name', with: 'My new gist'
        fill_in 'Url', with: gist_url

        click_on 'Edit'
      end

      expect(page).to have_link 'My new gist', href: gist_url
    end
  end
end
