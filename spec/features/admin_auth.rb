require 'rails_helper'

RSpec.feature 'Admin Sign In', type: :feature do
  scenario 'Admin can sign in with valid credentials' do
    admin = create(:user, :admin)
    visit new_user_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'user[password]', with: admin.password
    click_button 'Log in'
    expect(page).to have_text('Signed in successfully.')
  end

  # scenario 'user signs in' do
  #   user = create(:user)
  #   visit new_user_session_path

  #   fill_in 'user[email]', with: user.email
  #   fill_in 'user[password]', with: user.password
  #   click_button 'Log in'

  #   expect(page).to have_content('Signed in successfully.')
  # end
end
