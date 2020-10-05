require 'rails_helper'

feature 'User can add badge', %q{
  In order to award the best answer
  As an question's author
  I'd like to be able to add badge
} do

  given(:user) { create(:user) }

  scenario 'User adds badge when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Badge name', with: 'My badge'
    attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Ask'

    expect(user.questions.last.badge).to be_a(Badge)
  end
end
