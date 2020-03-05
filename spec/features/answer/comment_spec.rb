require 'rails_helper'

feature 'User can comment an answer' do
  describe 'An authenticated user', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    scenario 'comments an answer' do
      login(user)
      visit question_path(question)

      within '.answers div:first-child' do
        click_on 'Add comment'
        fill_in 'Your comment:', with: 'new comment body'
        click_on 'Post comment'
      end

      within '.answer-comments' do
        expect(page).to have_content 'new comment body'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    scenario 'comments an answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_link 'Add comment'
      end
    end
  end

  context 'multiple sessions' do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers div:first-child' do
          click_on 'Add comment'
          fill_in 'Your comment:', with: 'new comment body'
          click_on 'Post comment'
        end
        within '.answer-comments' do
          expect(page).to have_content 'new comment body'
        end
      end

      Capybara.using_session('guest') do
        within '.answer-comments' do
          expect(page).to have_content 'new comment body'
        end
      end
    end
  end
end
