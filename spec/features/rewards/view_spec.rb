# frozen_string_literal: true

require 'rails_helper'

feature 'User can view rewards', "
  In order to reject completed questions
  As an authenticated user
  I'd like to view my rewards
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:rewards) { create_list(:reward, 3, user: user, question: question) }

  scenario 'User views the list of rewards' do
    sign_in(user)
    visit rewards_path

    rewards.each do |reward|
      expect(page).to have_content question.title
      expect(page).to have_content reward.title
      expect(page).to have_content reward.picture
    end
  end
end
