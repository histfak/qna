require 'rails_helper'

feature 'User can delete a question' do
  given(:user) {create(:user)}
  given(:question) {create(:question)}

  describe 'Authenticated user' do

    scenario 'deletes his own question' do
      login(question.author)

      visit question_path(question)
      click_on 'Delete question'
      expect(page).to_not have_content 'test_title'
    end
    scenario 'tries to delete a question which belongs to another user'
  end

  scenario 'Unauthenticated user tries to delete a question'
end