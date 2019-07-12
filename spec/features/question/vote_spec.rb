require 'rails_helper'

feature 'User can vote for the question' do
  describe 'An authenticated user', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given(:question2) { create(:question, author: user) }

    scenario 'likes a question' do
      login(user)

      visit question_path(question)

      within '.question-voting-links' do
        click_on 'Like'
      end

      expect(page).to have_content 'Scores: 1'
    end

    scenario 'dislikes a question' do
      login(user)

      visit question_path(question)

      within '.question-voting-links' do
        click_on 'Dislike'
      end

      expect(page).to have_content 'Scores: -1'
    end

    scenario 'resets a question vote' do
      login(user)

      visit question_path(question)

      within '.question-voting-links' do
        click_on 'Like'
        click_on 'Reset'
      end

      expect(page).to have_content 'Scores: 0'
    end

    scenario 'cannot vote for his own question' do
      login(user)

      visit question_path(question2)

      expect(page).not_to have_button 'Like'
      expect(page).not_to have_button 'Dislike'
      expect(page).not_to have_button 'Reset'
    end
  end

  describe 'Unauthenticated user', js: true do
    given(:question) { create(:question) }

    scenario 'tries to vote' do
      visit question_path(question)

      expect(page).not_to have_button 'Like'
      expect(page).not_to have_button 'Dislike'
      expect(page).not_to have_button 'Reset'
    end
  end
end
