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
    # Add tests for user sign-in
  end

  scenario 'user signs out' do
    # Add tests for user sign-out
  end

  # Add more scenarios for authentication features
end
