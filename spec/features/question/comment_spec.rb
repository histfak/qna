require 'rails_helper'

feature 'User can comment a question' do
  describe 'An authenticated user', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario 'comments a question' do
      login(user)
      visit question_path(question)

      within '.question-new-comment' do
        click_on 'Add comment'
        fill_in 'Your comment:', with: 'new comment body'
        click_on 'Post comment'
      end

      within '.question-comments' do
        expect(page).to have_content 'new comment body'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    given(:question) { create(:question) }

    scenario 'comments a question' do
      visit question_path(question)

      expect(page).not_to have_link 'Add comment'
    end
  end

  context 'multiple sessions' do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question-new-comment' do
          click_on 'Add comment'
          fill_in 'Your comment:', with: 'new comment body'
          click_on 'Post comment'
        end
        within '.question-comments' do
          expect(page).to have_content 'new comment body'
        end
      end

      Capybara.using_session('guest') do
        within '.question-comments' do
          expect(page).to have_content 'new comment body'
        end
      end
    end
  end
end
