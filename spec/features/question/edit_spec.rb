require 'rails_helper'
feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:user_2) { create(:user) }
  given!(:url) {'http://rusrails.ru'}

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    describe 'Author' do
      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario 'edts his question', js: true do
        click_on 'Edit question'

        within '.question' do
          fill_in 'Title', with: 'q title'
          fill_in 'Body', with: 'q body'
          click_on 'Save'

          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to have_content 'q title'
          expect(page).to have_content 'q body'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his question with errors', js: true do
        click_on 'Edit question'
        within '.question' do
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_content question.title
          expect(page).to have_content question.body
        end
        expect(page).to have_content "Body can't be blank"
      end

      scenario "tries to add files", js: true do
        click_on 'Edit question'

        within ".question" do
          fill_in 'Body', with: 'q body'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'adds his new links when editing an question', js: true do
        click_on 'Edit question'

        within '.question' do
          click_on 'Add link'
          fill_in 'Link name', with: 'Rails'
          fill_in 'Url', with: url
          click_on 'Save'
        end

        expect(page).to have_link 'Rails', href: url
      end
    end

    describe 'Not author' do
      background do
        sign_in(user_2)

        visit question_path(question)
      end

      scenario "try to edit other user's question" do

        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
