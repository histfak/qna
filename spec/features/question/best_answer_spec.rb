require 'rails_helper'

feature 'User can set the best answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:any) { create(:answer, body: 'the oldest answer body', question: question) }
  given!(:best) { create(:answer, body: 'the default best answer body', best: true, question: question) }
  given!(:any2) { create(:answer, body: 'the newest answer body', question: question) }

  scenario 'Unauthenticated user tries to set the best answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Mark as the best'
  end

  scenario 'Any user sees the best answer first' do
    visit question_path(question)

    within '.answers div:first-child' do
      expect(page).to have_content 'the default best answer body'
    end
  end

  describe 'Authenticated user' do
    scenario 'sets the best answer to his question', js: true do
      login(user)

      visit question_path(question)

      within '.answers div:last-child' do
        click_on 'Mark as the best'
      end

      within '.answers div:first-child' do
        expect(page).to have_content 'the oldest answer body'
      end
    end

    scenario 'tries to set the best answer to the question which belongs to other user', js: true do
      login(user2)

      visit question_path(question)

      expect(page).not_to have_link 'Mark as the best'
    end
  end
end
