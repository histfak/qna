require 'rails_helper'

feature 'User can create an answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'posts an answer', js: true do
      within '.new-answer' do
        fill_in 'Your answer:', with: 'new answer body'
        click_on 'Post answer'
      end

      expect(page).to have_content 'Your answer has been successfully created.'
      expect(page).to have_content 'new answer body'
    end

    scenario 'posts an answer with errors', js: true do
      click_on 'Post answer'

      expect(page).not_to have_content 'Your answer has been successfully created.'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to post an answer' do
    visit question_path(answer.question)

    expect(page).not_to have_content 'Write your answer:'
    expect(page).not_to have_link 'Post answer'
  end
end
