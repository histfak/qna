require 'rails_helper'

feature 'User can sign out' do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign out' do
    login(user)

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
