require_relative  '../acceptance_helper'

feature 'User can delete an answer', %q{
  In order to manage my publications
  As an authenticated user and author of an answer
  I want to delete an answer
} do
  context 'Athenticated user wants to delete an answer' do
    given(:user){ create :user }
    given(:malicious_user){ create :user }
    given!(:question){ create :question }
    given!(:answer){ create :answer, question: question, user: user }  
    given!(:second_answer){ create :answer, question: question, user: user }  
    
    scenario 'Author of an answer deletes an answer', js: true do                   
      sign_in user
      visit question_path question        
      within("#answer_#{ answer.id }"){ click_on 'Delete' }      
      expect(page).to_not have_content "#{ answer.body }"
      expect(page).to_not have_selector "#error_#{ answer.id }"
      expect(page).to_not have_selector "#answer_dom_#{ answer.id }"
      expect(current_path).to eq question_path question      
    end

    scenario 'Not the author of a question try to delete a question' do      
      sign_in malicious_user
      visit question_path question       
      within("div.answers"){ expect(page).to_not have_content 'Delete' }              
    end
  end
   
end