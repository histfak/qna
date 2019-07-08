require 'rails_helper'

feature 'User answers and gets a reward' do
  describe 'Authenticated user' do
    given!(:user) { create(:user) }
    given!(:user2) { create(:user) }
    given!(:question) { create(:question, :with_reward, author: user) }
    given!(:answer) { create(:answer, question: question, author: user2) }

    scenario 'assigns a reward to the question' do
      login(user)
      visit new_question_path

      fill_in 'Title', with: 'Reward question'
      fill_in 'Body', with: 'text text text'
      fill_in 'Reward', with: 'Congrats!'
      attach_file 'Badge', "#{Rails.root}/public/badge.png"
      click_on 'Ask'

      expect(page).to have_content 'Congrats!'
      expect(page).to have_css("img[src*='badge.png']")
    end

    scenario 'achieves a reward for the best answer', js: true do
      login(user)
      visit question_path(question)

      within '.answers div:first-child' do
        click_on 'Mark as the best'
      end

      click_on 'Log out'

      login(user2)

      visit rewards_path

      expect(page).to have_content 'You are the best!'
      expect(page).to have_css("img[src*='badge.png']")
    end
  end
end
