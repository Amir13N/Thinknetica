require 'sphinx_helper'

feature 'User can search for users', "
  In order to find needed users
  As  an User
  I'd like to be able to search for users
" do
  given!(:users) { create_list(:user, 2) }

  scenario 'User can search for user', sphinx: true, js: true do
    visit users_path

    ThinkingSphinx::Test.run do
      fill_in 'search', with: users.first.email
      click_on 'Search'

      expect(page).to have_content users.first.email
      expect(page).to_not have_content users.last.email
    end
  end
end
