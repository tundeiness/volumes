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

  scenario 'user resets password' do
    user = create(:user)

    visit new_user_session_path
    click_link 'Forgot your password?'

    fill_in 'Email', with: user.email
    click_button 'Send me reset password instructions'

    expect(page).to have_content('You will receive an email with instructions on how to reset your password in a few minutes.')

    # Assuming you have a way to access the reset password link from the sent email
    reset_password_link = extract_reset_password_link_from_email(user.email)
    visit reset_password_link

    fill_in 'New password', with: 'new_password'
    fill_in 'Confirm new password', with: 'new_password'
    click_button 'Change my password'

    expect(page).to have_content('Your password has been changed successfully.')
  end

  scenario 'user deletes account' do
    user = create(:user)

    sign_in(user)
    visit edit_user_registration_path

    accept_confirm('Are you sure you want to delete your account?') do
      click_button 'Cancel my account'
    end

    expect(page).to have_content('Your account has been successfully cancelled.')
    expect(User.count).to eq(0)
  end
end
