require 'rails_helper'

feature 'User can vote for the answer' do
  describe 'An authenticated user', js: true do
    given!(:user) { create(:user) }
    given!(:question) { create(:question) }
    given!(:question2) { create(:question, author: user) }
    given!(:answer) { create(:answer, question: question) }
    given!(:answer2) { create(:answer, question: question2, author: user) }

    scenario 'likes an answer' do
      login(user)

      visit question_path(question)

      within '.answer-voting-links' do
        click_on 'Like'
      end

      within '.answer-scores' do
        expect(page).to have_content 'Scores: 1'
      end
    end

    scenario 'dislikes an answer' do
      login(user)

      visit question_path(question)

      within '.answer-voting-links' do
        click_on 'Dislike'
      end

      within '.answer-scores' do
        expect(page).to have_content 'Scores: -1'
      end
    end

    scenario 'resets an answer vote' do
      login(user)

      visit question_path(question)

      within '.answer-voting-links' do
        click_on 'Like'
        click_on 'Reset'
      end

      within '.answer-scores' do
        expect(page).to have_content 'Scores: 0'
      end
    end

    scenario 'votes twice' do
      login(user)

      visit question_path(question)

      within '.answer-voting-links' do
        click_on 'Like'
        expect(page).not_to have_content 'Like'
      end
    end

    scenario 're-votes' do
      login(user)

      visit question_path(question)

      within '.answer-voting-links' do
        click_on 'Like'
        click_on 'Reset'
        click_on 'Dislike'
      end

      within '.answer-scores' do
        expect(page).to have_content 'Scores: -1'
      end
    end

    scenario 'cannot vote for his own answer' do
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
