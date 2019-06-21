require 'rails_helper'

feature 'User can delete an answer' do
  given(:answer) {create(:answer, body: 'test body')}

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'tries to delete his own answer' do
      login(answer.author)

      visit question_path(answer.question)
      click_on 'Delete answer'
      expect(page).to_not have_content 'test body'
    end
    scenario 'tries to delete an answer which belongs to another user' do
      login(user)

      visit question_path(answer.question)
      expect(page).not_to have_content 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(answer.question)
    expect(page).not_to have_content 'Delete answer'
  end
end