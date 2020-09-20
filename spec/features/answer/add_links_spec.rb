require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:url) { 'http://rusrails.ru' }

  scenario 'User adds link when create answer', js: true do
    sign_in(user)
    visit question_path(question)

    within ".new-answer" do
      fill_in 'Body', with: 'text'
      fill_in 'Link', with: 'Rails'
      fill_in 'Url', with: url

      click_on 'Answer'
    end

    expect(page).to have_link 'Rails', href: url
  end
end
