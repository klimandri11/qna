require 'rails_helper'

feature 'User can choose best answer', %q{
  In order to get answer from a community
  As an author of question
  I'd like to be able to choose best answer for my question
} do

  given!(:user) { create(:user) }
  given!(:user_2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 10, question: question, user: user) }

  describe 'Authenticated user' do
    describe 'Author' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'chooses the best answer', js: true do
        click_on "Best", match: :first

        expect(page).to have_link('Best', count: 9)
      end

      scenario 'one best answer', js: true do
        within("#answer-#{answers.first.id}") { click_on 'Best' }
        within("#answer-#{answers.last.id}") { click_on 'Best' }

        expect(page).to have_link('Best', count: 9)
      end
    end

    describe 'Not author' do
      scenario "does not see the link" do
        sign_in(user_2)
        visit question_path(question)
        expect(page).to_not have_link 'Best'
      end
    end
  end

  scenario 'Unauthenticated can not choose the best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Best'
  end
end
