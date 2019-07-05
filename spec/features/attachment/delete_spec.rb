require 'rails_helper'

feature 'User can delete attached files' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, :with_files, author: user) }
  given!(:answer) { create(:answer, :with_files, question: question, author: user) }

  describe 'Authenticated user' do
    scenario 'deletes his own file attached to the question', js: true do
      login(user)
      visit question_path(question)
      grabbed_filename = question.files.first.filename.to_s

      within '.question' do
        click_on 'Delete file'
      end

      expect(page).to_not have_link grabbed_filename
    end

    scenario 'tries to delete files attached to the question which belongs to other user', js: true do
      login(user2)
      visit question_path(question)

      within '.question' do
        expect(page).to have_link question.files.first.filename.to_s
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario 'deletes his own file attached to the answer', js: true do
      login(user)
      visit question_path(question)
      grabbed_filename = answer.files.first.filename.to_s

      within '.answers div:first-child' do
        click_on 'Delete file'
      end

      expect(page).to_not have_link grabbed_filename
    end

    scenario 'tries to delete the file attached to the answer which belongs to other user', js: true do
      login(user2)
      visit question_path(question)

      within '.answers div:first-child' do
        expect(page).to have_link answer.files.first.filename.to_s
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete attached files', js: true do
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end
end
