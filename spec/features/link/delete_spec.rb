require 'rails_helper'

feature 'User can delete attached links' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, :with_links, author: user) }
  given!(:answer) { create(:answer, :with_links, question: question, author: user) }

  describe 'Authenticated user' do
    scenario 'deletes his own link to the question', js: true do
      login(user)
      visit question_path(question)
      grabbed_linkname = question.links.first.name

      within '.question' do
        click_on 'Delete link'
      end

      expect(page).to_not have_link grabbed_linkname
    end

    scenario 'tries to delete links attached to the question which belongs to other user', js: true do
      login(user2)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Delete link'
      end
    end

    scenario 'deletes his own link attached to the answer', js: true do
      login(user)
      visit question_path(question)
      grabbed_linkname = answer.links.first.name

      within '.answers div:first-child' do
        click_on 'Delete link'
      end

      expect(page).to_not have_link grabbed_linkname
    end

    scenario 'tries to delete the link attached to the answer which belongs to other user', js: true do
      login(user2)
      visit question_path(question)

      within '.answers div:first-child' do
        expect(page).to_not have_link 'Delete link'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete link', js: true do
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end
end
