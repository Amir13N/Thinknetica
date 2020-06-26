require 'rails_helper'

feature 'User can log in', %q{
  In order to change user
  As an authenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'Authenticated user signs out' do
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end