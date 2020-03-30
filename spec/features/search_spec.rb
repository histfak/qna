require 'sphinx_helper'

feature 'Search' do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given!(:match_question) { create(:question, title: 'phrase') }
    given!(:questions) { create_list(:question, 3) }
    given!(:match_answer) { create(:answer, body: 'phrase') }
    given!(:answers) { create_list(:answer, 3) }

    background do
      login(user)
      visit questions_path
    end

    scenario 'looks for the phrase', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: 'phrase'
        click_on 'Search'

        expect(page).to have_content '2 result(s):'
        expect(page).to have_content match_question.title
        expect(page).to have_content match_answer.body
      end
    end

    scenario 'looks for the phrase in a specific resource', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        select 'Answer', from: 'search_type'
        fill_in 'Search', with: 'phrase'
        click_on 'Search'

        expect(page).to have_content '1 result(s):'
        expect(page).to have_content match_answer.body
      end
    end

    scenario 'looks for the phrase that does not exist', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: 'something'
        click_on 'Search'

        expect(page).to have_content 'Nothing'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'unable to search' do
      visit questions_path

      expect(page).not_to have_button 'Search'
    end
  end
end
