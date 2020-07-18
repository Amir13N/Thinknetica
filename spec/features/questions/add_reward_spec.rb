require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Amir13N/3e9944d6f3f7d0e7ccaa73639c8f94d6' }

  background { create(:question, user: user) }

  scenario 'User adds reward when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within '.reward-form' do
      fill_in 'Title', with: 'My reward'
      fill_in 'Url', with: 'https://avatarko.ru/img/kartinka/13/TMNT_Michelangelo_12859.jpg'
    end

    click_on 'Ask'

    expect(page).to have_link 'My reward', href: gist_url
    expect(page).to_not have_link 'My gist1', href: gist_url
  end
end
