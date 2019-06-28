require 'rails_helper'

feature 'User can set the best answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:best) { create(:answer, body: 'the best answer body', question: question) }

  scenario 'Unauthenticated user tries to set the best answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Mark as the best'
  end

  describe 'Authenticated user' do
    scenario 'sets the best answer to his question', js: true do
      login(user)

      visit question_path(question)

      within ".answer-#{best.id}" do
        click_on 'Mark as the best'
      end

      expect(page.find(".answers div:first-child").text).to eq 'the best answer body'
    end

    scenario 'tries to set the best answer to the question which belongs to other user', js: true do
      login(user2)

      visit question_path(question)

      expect(page).not_to have_link 'Mark as the best'
    end
  end
end
