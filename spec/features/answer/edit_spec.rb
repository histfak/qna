require 'rails_helper'

feature 'User can edit his answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user cannot edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      login(user)

      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Edit answer:', with: 'edited answer'
        click_on 'Update answer'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end
    scenario 'edits his answer with errors'
    scenario 'tries to edit the answer which belongs to other user'
  end
end
