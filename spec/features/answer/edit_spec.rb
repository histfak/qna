require 'rails_helper'

feature 'User can edit his answer' do
  given(:user) {create(:user)}
  given(:user2) {create(:user)}
  given(:question) {create(:question)}
  given!(:answer) {create(:answer, question: question, author: user)}

  scenario 'Unauthenticated user cannot edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      login(user)

      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Edit answer:', with: 'edited answer'
        click_on 'Update answer'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end
    scenario 'edits his answer with errors', js: true do
      login(user)

      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Edit answer:', with: ''
        click_on 'Update answer'
      end

      expect(page).to have_content answer.body
      expect(page).to have_content "Body can't be blank"
    end
    scenario 'tries to edit the answer which belongs to other user', js: true do
      login(user2)
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end
