require 'rails_helper'

feature 'Show questions list' do
  given!(:questions) { create_list(:question, 3) }

  scenario 'User wants to see a list of questions' do
    visit questions_path

    questions.each { |q| expect(page).to have_content q.title }
  end
end
