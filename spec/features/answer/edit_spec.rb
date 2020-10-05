require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:user_2) { create(:user) }
  given!(:url) {'http://rusrails.ru'}

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    describe 'Author' do
      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario 'edits his answer' do
        click_on 'Edit'

        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his answer with errors' do
        click_on 'Edit'

        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_content answer.body
        end
        expect(page).to have_content "Body can't be blank"
      end

      scenario "tries to add files", js: true do
        click_on 'Edit'

        within '.answers' do
          fill_in 'Your answer', with: 'a body'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'adds his new links when editing an answer', js: true do
        click_on 'Edit'

        within '.answers' do
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

      scenario "try to edit other user's answer" do
        expect(page).to_not have_button 'Edit'
      end
    end

  end
end
