require 'rails_helper'

feature 'User can create an answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'posts an answer', js: true do
      within '.new-answer' do
        fill_in 'Your answer:', with: 'new answer body'
        click_on 'Post answer'
      end

      expect(page).to have_content 'Your answer has been successfully created.'
      expect(page).to have_content 'new answer body'
    end

    scenario 'posts an answer with errors', js: true do
      click_on 'Post answer'

      expect(page).not_to have_content 'Your answer has been successfully created.'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'posts an answer with attached files', js: true do
      within '.new-answer' do
        fill_in 'Your answer:', with: 'new answer body'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Post answer'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to post an answer' do
    visit question_path(answer.question)

    expect(page).not_to have_content 'Write your answer:'
    expect(page).not_to have_link 'Post answer'
  end

  context 'multiple sessions' do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question, author: user) }

    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-answer' do
          fill_in 'Your answer:', with: 'new answer body'
          click_on 'Post answer'
        end

        expect(page).to have_content 'Your answer has been successfully created.'
        expect(page).to have_content 'new answer body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'new answer body'
      end
    end
  end
end
