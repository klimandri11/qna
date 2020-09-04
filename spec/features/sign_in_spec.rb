require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registreted user tries to sign in' do
    sign_in(user)

    #save_and_open_page # для перехода на страницу тестирования
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistreted user triws tosign in' do
    visit new_user_session_path
    
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
