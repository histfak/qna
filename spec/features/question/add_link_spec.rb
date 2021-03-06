require 'rails_helper'

feature 'User can add links to question' do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/histfak/ba9a3358cbe5e99563b7a56b5ae0dc4a' }
  given(:invalid_url) { 'foobar' }
  given(:regular_url) { 'http:/google.com' }

  scenario 'User adds link when asks question', js: true do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'

    fill_in 'Link name', with: 'My link'
    fill_in 'URL', with: regular_url

    click_on 'Ask'

    expect(page).to have_link 'My link', href: regular_url
  end

  scenario 'User adds invalid link when asks question', js: true do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'

    fill_in 'Link name', with: 'My link'
    fill_in 'URL', with: invalid_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
  end

  scenario 'User adds gist link when asks question', js: true do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'

    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: gist_url

    click_on 'Ask'

    expect(page).to have_content 'Hello, world!'
  end
end
