require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to rate favorite question
  User as an authenticated user can vote
} do
  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given(:user_3) { create(:user) }
  given(:user_4) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question_2) { create(:question, user: user_2) }

  describe 'Authenticated user', js: true do
    describe 'Not author' do
      background do
        sign_in(user)
        visit question_path(question_2)
      end

      scenario 'tries vote for' do
        within "#vote-question-#{question_2.id}" do
          click_on 'Up'
          expect(page).to have_content '1'
        end
      end

      scenario 'tries vote against' do
        within "#vote-question-#{question_2.id}" do
          click_on 'Down'
          expect(page).to have_content '-1'
        end
      end

      scenario 'tries vote only once' do
        within "#vote-question-#{question_2.id}" do
          click_on 'Down'
          expect(page).to have_content '-1'
          expect(page).to_not have_content 'Up'
          expect(page).to_not have_content 'Down'
        end
      end

      scenario 'tries unvote' do
        within "#vote-question-#{question_2.id}" do
          click_on 'Up'
          expect(page).to_not have_content 'Up'
          expect(page).to_not have_content 'Down'
          expect(page).to have_link 'Unvote'
          expect(page).to have_content '1'

          click_on 'Unvote'
          expect(page).to_not have_link 'Unvote'
          expect(page).to have_content 'Up'
          expect(page).to have_content 'Down'
          expect(page).to have_content '0'
        end
      end

      scenario 'tries vote for and against the question' do
        within "#vote-question-#{question_2.id}" do
          click_on 'Up'
          expect(page).to have_content '1'
        end

        click_on 'Logout'
        sign_in(user_3)
        visit question_path(question_2)
        within "#vote-question-#{question_2.id}" do
          click_on 'Up'
          expect(page).to have_content '2'
        end

        click_on 'Logout'
        sign_in(user_4)
        visit question_path(question_2)
        within "#vote-question-#{question_2.id}" do
          click_on 'Down'
          expect(page).to have_content '1'
        end
      end
    end

    describe 'Author' do
      background do
        sign_in(user_2)
        visit question_path(question_2)
      end

      scenario "tries vote for their question" do

        within ".question" do
          expect(page).to_not have_content 'down'
          expect(page).to_not have_content 'up'
        end
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario "can't vote for the question" do
      visit question_path(question)

      within ".question" do
        expect(page).to_not have_content 'Down'
        expect(page).to_not have_content 'Up'
      end
    end
  end
end
