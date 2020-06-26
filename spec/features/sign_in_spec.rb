require 'rails_helper'

feature 'User can log in', %q{
  In order to ask questions
  As an authenticated user
  I'd like to be able to sign up
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }
  
  scenario 'Registered user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Uregistered user tries to sign up' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end