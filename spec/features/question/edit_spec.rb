require 'rails_helper'

feature 'User can edit his question' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'Unauthenticated user cannot edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      login(user)

      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Edit question:', with: 'edited question'
        click_on 'Update question'

        expect(page).not_to have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).not_to have_selector 'textarea'
      end
    end
    scenario 'edits his question with errors', js: true do
      login(user)

      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Edit question:', with: ''
        click_on 'Update question'
      end

      expect(page).to have_content question.body
      expect(page).to have_content "Body can't be blank"
    end
    scenario 'tries to edit the question which belongs to other user', js: true do
      login(user2)
      visit question_path(question)

      within '.question' do
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end
