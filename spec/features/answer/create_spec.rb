require 'rails_helper'

feature 'User can create answer the question', %q{
  In order to give answer to a community
  As an authenticated user
  I'd like to be able to create answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'create a answer' do
      fill_in 'Body', with: 'text'
      click_on 'Answer'

      within('.answer-body') { expect(page).to have_content 'text' }
    end

    scenario 'create a answer with errors' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)

    expect(page).to_not have_content "Answer"
  end


end
