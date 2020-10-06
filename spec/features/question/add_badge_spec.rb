require 'rails_helper'

feature 'User can add badge', %q{
  In order to award the best answer
  As an question's author
  I'd like to be able to add badge
} do

  given(:user) { create(:user) }
  given(:user_2) { create(:user) }

  scenario 'User adds badge when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Badge name', with: 'My badge'
    attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Ask'
    click_on 'Logout'

    sign_in(user_2)
    click_on 'Show'
    fill_in 'Body', with: 'text'
    click_on 'Answer'
    click_on 'Logout'

    sign_in(user)
    click_on 'Show'
    click_on 'Best'
    click_on 'Logout'

    sign_in(user_2)
    visit badges_path

    expect(page).to have_content 'My badge'
    expect(page).to have_css 'img'
  end
end
