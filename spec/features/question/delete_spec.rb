require 'rails_helper'

feature 'User can delete a question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, title: 'test_title') }

  describe 'Authenticated user' do

    scenario 'tries to delete his own question' do
      login(question.author)

      visit question_path(question)
      click_on 'Delete question'
      expect(page).to_not have_content 'test_title'
    end
    scenario 'tries to delete a question which belongs to another user' do
      login(user)

      visit question_path(question)
      expect(page).not_to have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)
    expect(page).not_to have_link 'Delete question'
  end
end
