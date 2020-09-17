require 'rails_helper'

feature 'User can delete question file', %q{
  As an authenticated user
  I'd like to be able to delete file of my question
  And no one except me can delete my file
} do

  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question_file) { question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }

  describe 'Authenticated user' do
    describe 'Author' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'is trying to delete their file', js: true do
        within '.question' do
          expect(page).to have_content 'rails_helper.rb'
          click_on 'Delete file'

          expect(page).to_not have_content 'rails_helper.rb'
        end
      end
   end

   describe 'Not author' do
     background do
       sign_in(user_2)
       visit question_path(question)
     end

     scenario "is trying to delete someone else's file", js: true do
       expect(page).to_not have_link 'Delete file'
     end
   end
  end

  scenario "Unauthenticated user is trying to delete file", js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end
end
