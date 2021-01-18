# frozen_string_literal: true

require 'rails_helper'

feature 'User can log in', "
  In order to ask questions
  As an authenticated user
  I'd like to be able to sign up
" do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user signs in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  describe 'Unregistered user' do
    scenario 'tries to sign in' do
      fill_in 'Email', with: 'wrong@test.com'
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end

    scenario 'tries to sign in with Vkontakte login'
  end
end
