# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Amir13N/3e9944d6f3f7d0e7ccaa73639c8f94d6' }
  given(:picture_url) { 'https://avatarko.ru/img/kartinka/13/TMNT_Michelangelo_12859.jpg' }

  scenario 'User adds reward when asks question' do
    sign_in(user)
    visit new_question_path

    within '.main-form' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    within '.reward-form' do
      fill_in 'Title', with: 'My reward'
      fill_in 'Picture', with: picture_url
    end

    click_on 'Ask'

    expect(page).to have_content 'My reward'
    expect(page).to have_content picture_url
  end
end
