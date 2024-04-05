require 'rails_helper'

RSpec.configure do |config|
  config.include EmailHelper, type: :feature
end

RSpec.feature 'UserAuths', type: :feature do

  scenario 'user signs up' do
    visit new_user_registration_path

    fill_in 'user[email]', with: 'test@example.com'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(User.count).to eq(1)
  end

  scenario 'user signs up as a client' do
    visit new_user_registration_path
    fill_in 'Email', with: 'client@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    p User.last.role
    expect(User.last.role).to eq 'client'
    expect(User.count).to eq(1)
  end

  # scenario 'admin changes another user role from client to therapist' do
  #   admin = create(:user, :admin)
  #   user = create(:user, :client, email: 'user@example.com')

  #   login_as(admin, scope: :admin)
  #   puts "Visiting edit page for user #{user.id}"
  #   visit edit_user_path(user)
   
  #   select 'therapist', from: 'user_role'

  #   click_button 'Update'

  #   expect(page).to have_content 'User role updated successfully.'
  #   expect(user.reload.role).to eq 'therapist'
  # end

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

    click_button('Sign Out')

    expect(page).to have_content('Signed out successfully.')
  end

  # Add more scenarios for authentication features
  scenario 'user resets password' do
    user = create(:user)

    # Trigger password reset
    visit new_user_password_path
    fill_in 'Email', with: user.email
    click_button 'Send me reset password instructions'

    # Extract reset password link from email
    reset_password_link = extract_reset_password_link_from_email(ActionMailer::Base.deliveries.last)

    # Visit reset password link
    visit reset_password_link

    # Enter new password
    fill_in 'New password', with: 'new_password'
    fill_in 'Confirm new password', with: 'new_password'
    click_button 'Change my password'

    expect(page).to have_content('Your password has been changed successfully. You are now signed in.')
  end

  scenario 'user deletes account' do
    user = create(:user)

    # Manually sign in the user using Warden
    login_as(user, scope: :user)

    visit edit_user_registration_path

    expect(page).to have_content('Cancel my account')

    click_button 'Cancel my account'

    expect(page).to have_content('Your account has been successfully cancelled.')
    expect(User.count).to eq(0)
  end


  scenario 'user changes email' do
    user = create(:user)
    new_email = 'new_email@example.com'

    login_as(user, scope: :user)
    visit edit_user_registration_path

    fill_in 'Email', with: new_email
    fill_in 'Current password', with: user.password
    click_button 'Update'

    # Ensure that the user's email is updated with the unconfirmed email
    user.reload
    expect(user.email).to eq(new_email)

    # Adjust the expectation to match the actual content
    expect(page).to have_content('Your account has been updated successfully.')
  end
end
