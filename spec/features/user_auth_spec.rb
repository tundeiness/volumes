require 'rails_helper'

RSpec.feature 'UserAuths', type: :feature do
  # let(:user) { create(:user) }

  scenario 'user signs up' do
    visit new_user_registration_path

    fill_in 'user[email]', with: 'test@example.com'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(User.count).to eq(1)
  end

  scenario 'user signs in' do
    # create user using FactortBot
    user = create(:user)
    # save_and_open_page
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'user signs out' do
    # create user using FactortBot
    user = create(:user)

    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'

    expect(page).to have_content('Signed in successfully.')

    click_link('Sign out')

    expect(page).to have_content('Signed out successfully.')
  end

  # Add more scenarios for authentication features
end
