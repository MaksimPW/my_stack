require 'rails_helper'

feature 'user sign out', %q{
  In order to quit current session
  As a user
  I whant to sign out
} do 

  given(:user){ create(:user) }

  scenario "Registerd  and logged in user try's to sign out" do     
    sign_in user
    save_and_open_page
    expect(page).to have_content "Sign out"
    click_on "Sign out"
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

end