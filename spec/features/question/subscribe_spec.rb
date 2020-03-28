require 'rails_helper'

feature 'User can edit his question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

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
        click_on 'Subscribe'
        expect(page).not_to have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
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
      login(user)

      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      within '.question-subscribe' do
        expect(page).not_to have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end
    end
  end
end
