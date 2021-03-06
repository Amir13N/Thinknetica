# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', "
  In order to create account and ask questions
  As an unauthenticated user
  I'd like to be able to sign up
" do
  scenario 'Registered user signs up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    open_email('user@test.com')
    current_email.click_on 'Confirm my account'
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end
end
