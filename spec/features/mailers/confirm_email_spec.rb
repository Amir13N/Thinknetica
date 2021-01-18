require 'rails_helper'

feature 'User can send email confirmation message', "
  In order to log in
  With social media account
  I'd like to be able to receive email confirmation message
" do
  background do
    visit new_user_session_path
    click_on 'Sign in with Vkontakte'

    fill_in 'Email', with: 'test@example.com'
    click_on 'Send email confirmation message'

    open_email('test@example.com')
  end

  scenario 'allows to log in with provider account' do
    current_email.click_on 'Confirm email'

    visit new_user_session_path
    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
  end

  scenario 'has appropriate content' do
    expect(current_email).to have_content 'Click the button below to confirm your email'
  end
end
