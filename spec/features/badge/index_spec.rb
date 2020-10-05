require 'rails_helper'

feature 'User can show badges', %q{
  In order to view a list of your awards
  I'd like to be able to view my badges
} do

  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given!(:badge) { create :badge, question: question, user: user}

  scenario 'User can browse badges', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text text'
    click_on 'Answer'
    click_on 'Best'

    visit badges_path

    expect(page).to have_content question.title
    expect(page).to have_content badge.name
    expect(page).to have_selector '.badges'
  end
end
