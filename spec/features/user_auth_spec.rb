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

  scenario 'admin changes user role from client to therapist' do
    admin = create(:user, :admin)
    user = create(:user)

    # Sign in as admin
    login_as(admin, scope: :user)

    # Visit the page where admin can change user roles
    visit edit_user_path(user)

    # Verify that admin is on the correct page
    expect(page).to have_content('Change User Role')

    # Admin changes the user's role to therapist
    select 'therapist', from: 'user[role]'
    click_button 'Update'

    # Verify that the user's role has been updated successfully
    expect(page).to have_content('User role updated successfully.')
    expect(user.reload.role).to eq('therapist')
  end

  scenario 'admin cannot change their own role' do
    admin = create(:user, :admin)

    # Sign in as admin
    login_as(admin, scope: :user)
    visit edit_user_path(admin)

    expect(page).to have_content('Admin cannot change their own role.')
    expect(page).not_to have_selector('form[action="/users/update"]')
  end


  scenario 'regular user cannot access role change page' do
    admin = create(:user, :admin)
    regular_user = create(:user)

    login_as(regular_user, scope: :user)
    visit edit_user_path(admin)
    expect(page).to have_content('You are not authorized to access this page.')
  end

  scenario 'user signs in' do
    user = create(:user)

    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'user signs out' do

    user = create(:user, :client)

    login_as(user)
    visit root_path

    expect(page).to have_content(user.email)

    click_button('Sign Out')
    # save_and_open_page
    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_link('Sign up')
    expect(page).to have_button('Log in')
    expect(page).to_not have_link('Sign Out')
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

    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(current_path).to eq(new_user_session_path)
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

    user.reload
    expect(user.email).to eq(new_email)

    expect(page).to have_content('Your account has been updated successfully.')
  end
end
