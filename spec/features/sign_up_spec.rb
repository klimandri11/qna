require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
} do

  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregistreted user tries to sign up' do
    fill_in 'Email', with: 'registr@test.com'
    fill_in 'Password', with: 'registr12'
    fill_in 'Password confirmation', with: 'registr12'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registreted user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password

    click_on 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Unregistered user tries to sing up with error' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

end
