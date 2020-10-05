require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:url) { 'http://rusrails.ru' }
  given(:invalid_url) { 'qazwsx'}

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'Rails'
    fill_in 'Url', with: url

    click_on 'Add link'

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'Rails_2'
      fill_in 'Url', with: url
    end

    click_on 'Ask'

    expect(page).to have_link 'Rails', href: url
    expect(page).to have_link 'Rails_2', href: url
  end

  scenario 'User adds invalid link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'Invalid'
    fill_in 'Url', with: invalid_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is an invalid URL'
    expect(page).to_not have_link 'Invalid', href: invalid_url
  end
end
