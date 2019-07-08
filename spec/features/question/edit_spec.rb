require 'rails_helper'

feature 'User can edit his question' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:question_with_files) { create(:question, :with_files, author: user) }
  given(:question_with_links) { create(:question, :with_links, author: user) }
  given(:regular_url) { 'http:/google.com' }

  scenario 'Unauthenticated user cannot edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      login(user)

      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Edit question:', with: 'edited question'
        click_on 'Update question'

        expect(page).not_to have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edits his attachment', js: true do
      login(user)

      visit question_path(question_with_files)

      within '.question' do
        click_on 'Edit'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Update question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his links', js: true do
      login(user)

      visit question_path(question_with_links)

      within '.question' do
        click_on 'Edit'
        fill_in 'Link name', with: 'My link'
        fill_in 'URL', with: regular_url
        click_on 'Update question'

        expect(page).to have_link 'My link', href: regular_url
      end
    end

    scenario 'edits his question with errors', js: true do
      login(user)

      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Edit question:', with: ''
        click_on 'Update question'
      end

      expect(page).to have_content question.body
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to edit the question which belongs to other user', js: true do
      login(user2)

      visit question_path(question)

      within '.question' do
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end
