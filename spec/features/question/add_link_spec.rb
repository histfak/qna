require 'rails_helper'

feature 'User can add links to question' do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/histfak/ba9a3358cbe5e99563b7a56b5ae0dc4a' }
  given(:invalid_url) { 'foobar' }

  scenario 'User adds link when asks question' do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end


  scenario 'User adds invalid link when asks question' do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: invalid_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
  end
end
