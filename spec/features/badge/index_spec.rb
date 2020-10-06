require 'rails_helper'

feature 'User can show badges', %q{
  In order to view a list of your awards
  I'd like to be able to view my badges
} do

  given(:user) { create :user }
  given(:question) { create :question, user: user }

  scenario 'Authenticated user tries to browse badges', js: true do
    sign_in(user)
    badges = create_list(:badge, 4, user: user, question: question)
    visit badges_path

    badges.each do |badge|
      expect(page).to have_content badge.question.title
      expect(page).to have_content badge.name
      expect(page).to have_css 'img'
    end
  end

  scenario 'Unauthenticated user tries to browse badges' do
    visit questions_path
    
    expect(page).to_not have_link 'Badges'
  end
end
