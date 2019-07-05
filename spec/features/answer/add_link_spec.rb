require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/histfak/ba9a3358cbe5e99563b7a56b5ae0dc4a' }

  scenario 'User adds link when asks answer', js: true do
    login(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Your answer:', with: 'new answer body'

      fill_in 'Link name', with: 'My gist'
      fill_in 'URL', with: gist_url

      click_on 'Post answer'
    end

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
