require_relative  '../acceptance_helper'

feature 'create question', %q{
  In order to get an answer from community
  As an authenticated user
  I want to be able to ask questions
} do 
  given(:user){ create :user }
  scenario 'Authenticated user creates question' do 
    sign_in user     

    visit questions_path
    click_on 'Ask question'
    
    fill_in 'Title', with:'test question'
    fill_in 'Body', with:'text text'
    click_on 'Create'
    expect(page).to have_content 'Question was successfully created.'    
    within('.question') do
      expect(page).to have_content 'test question'    
      expect(page).to have_content 'text text'     
    end       
  end
  scenario 'Non authenticated user tries to create a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path    
  end
end