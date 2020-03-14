require 'rails_helper'

feature 'User can edit his question' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given(:own_question) { create(:question, author: author) }

  scenario 'Unauthenticated user cannot subscribe to a question' do
    visit question_path(question)

    within '.question-subscribe' do
      expect(page).not_to have_link 'Subscribe'
      expect(page).not_to have_link 'Unsubscribe'
    end
  end

  describe 'Authenticated user' do
    scenario 'subscribes to a question', js: true do
      login(user)

      visit question_path(question)

      within '.question-subscribe' do
        expect(page).to have_link 'Subscribe'
        expect(page).not_to have_link 'Unsubscribe'
      end
    end

    scenario 'unsubscribes to a question', js: true do
      login(user)

      visit question_path(question)

      within '.question-subscribe' do
        click_on 'Subscribe'
        expect(page).not_to have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end
    end

    scenario 'owner unsubscribes to a question', js: true do
      login(author)

      visit question_path(own_question)

      within '.question-subscribe' do
        expect(page).not_to have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end
    end
  end
end
