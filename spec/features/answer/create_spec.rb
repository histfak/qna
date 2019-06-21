require 'rails_helper'

feature 'User can create an answer' do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(answer.question)
    end

    scenario 'posts an answer' do
      fill_in 'Your answer:', with: 'answer body'

      click_on 'Post answer'

      expect(page).to have_content 'Your answer has been successfully created.'
      expect(page).to have_content 'answer body'
    end
  end

  scenario 'Unauthenticated user tries to post an answer' do
    visit question_path(answer.question)

    expect(page).not_to have_content 'Write your answer:'
    expect(page).not_to have_content 'Post answer'
  end
end