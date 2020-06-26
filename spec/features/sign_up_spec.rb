require 'rails_helper'

feature 'User can sign up', %q{
  In order to create account and ask questions
  As an unauthenticated user
  I'd like to be able to sign up
} do
  scenario 'Registered user tries to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'
  end
end