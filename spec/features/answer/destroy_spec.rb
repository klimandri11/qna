require 'rails_helper'

feature 'User can delete answer', %q{
  As an authenticated user
  I'd like to be able to delete my answer
  And only I can delete my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  given(:user_2) { create(:user) }
  given!(:question_2) { create(:question, user: user_2) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'is try to delete their answer' do
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to_not have_content "Answer was destroyed"
      expect(page).to_not have_content answer.body
    end

    scenario "is try to delete someone else's answer" do
      visit question_path(question_2)

      expect(page).to_not have_content 'Delete answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario "is try to delete someone answer" do
      visit question_path(question)
      expect(page).to_not have_content 'Delete answer'
    end
  end
end
