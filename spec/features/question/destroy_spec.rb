require 'rails_helper'

feature 'User can delete question', %q{
  As an authenticated user
  I'd like to be able to delete my question
  And only I can delete my question
} do

  given(:user) {create(:user)}
  given(:user_2) {create(:user)}
  given(:question) {create(:question, user: user)}

  describe 'Authenticated user' do
    scenario 'is try to delete their question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Question was destroyed'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario "is try to delete someone else's question" do
      sign_in(user_2)
      visit question_path(question)

      expect(page).to_not have_content 'Delete question'
    end
  end

  describe 'Unauthenticated user' do
    scenario "is try to delete someone question" do
      visit question_path(question)
      expect(page).to_not have_content 'Delete question'
    end
  end
end
