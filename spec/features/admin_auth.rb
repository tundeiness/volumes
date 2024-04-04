require 'rails_helper'

RSpec.feature 'Admin Sign In', type: :feature do
  scenario 'Admin can sign in with valid credentials' do
    admin = create(:user, :admin)
    visit new_user_session_path
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Log in'
    expect(page).to have_text('Signed in successfully.')
  end
end
