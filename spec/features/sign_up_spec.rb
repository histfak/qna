require 'rails_helper'

feature 'User can sign up' do
  background do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
  end

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with confirmation error' do
    fill_in 'Password confirmation', with: '87654321'
    click_on 'Sign up'

    expect(page).not_to have_content 'Welcome! You have signed up successfully.'
  end
end
