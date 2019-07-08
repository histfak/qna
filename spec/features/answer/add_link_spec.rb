require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/histfak/ba9a3358cbe5e99563b7a56b5ae0dc4a' }
  given(:invalid_url) { 'foobar' }
  given(:regular_url) { 'http:/google.com' }

  scenario 'User adds link when asks answer', js: true do
    login(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Your answer:', with: 'new answer body'

      fill_in 'Link name', with: 'My link'
      fill_in 'URL', with: regular_url

      click_on 'Post answer'
    end

    within '.answers' do
      expect(page).to have_link 'My link', href: regular_url
    end
  end

  scenario 'User adds invalid link when asks answer', js: true do
    login(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Your answer:', with: 'new answer body'

      fill_in 'Link name', with: 'My gist'
      fill_in 'URL', with: invalid_url

      click_on 'Post answer'
    end

    within '.answer-errors' do
      expect(page).to have_content 'Links url is invalid'
    end
  end

  scenario 'User adds gist link when asks answer', js: true do
    login(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Your answer:', with: 'new answer body'

      fill_in 'Link name', with: 'My gist'
      fill_in 'URL', with: gist_url

      click_on 'Post answer'
    end

    within '.answers' do
      expect(page).to have_content 'Hello, world!'
    end
  end
end
