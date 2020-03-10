require 'rails_helper'

feature 'Authorization with OAuth' do
  describe 'Github' do
    let(:user) { create(:user) }

    scenario 'user tries to login with Github', js: true do
      auth = mock_auth_hash(:github)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from github account.'
    end
  end

  describe 'Facebook' do
    let(:user) { create(:user) }

    scenario 'user tries to login with Facebook', js: true do
      auth = mock_auth_hash(:facebook)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from facebook account.'
    end
  end
end
