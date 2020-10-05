require 'rails_helper'

feature 'User can delete link', %q{
  As an authenticated user
  I'd like to be able to delete link of my question
  And no one except me can delete my link
} do

  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create :link, name: 'Rails', url: 'http://rusrails.ru', linkable: question }

  describe 'Authenticated user' do

    describe 'Author', js: true do

      scenario "is tying to delete link" do
        sign_in(user)
        visit question_path(question)
        expect(page).to have_content 'Rails'

        click_on 'Delete link'

        expect(page).to_not have_content 'Rails'
      end
    end

    describe 'Not author' do

      scenario "is trying to delete someone else's link", js: true do
        sign_in(user_2)
        visit question_path(question)
        
        expect(page).to_not have_link 'Delete link'
      end
    end
  end

  describe 'Unauthenticate user', js: true do
    scenario "tying to delete link" do
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end
end
