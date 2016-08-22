require_relative '../acceptance_helper'

feature 'Add comment to answer', %q{
  In order to clearify information
  As a registered user
  I want to add a comment
} do 
  
  given(:user){ create :user }
  given!(:question){ create :question, user: user }
  given!(:answer){ create :answer, question: question, user: user }
     
  
  context 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end
    
    context 'Valid attributes' do      
      scenario 'Can create a comment', js: true  do
        within("#answer_#{answer.id}_comments") do
          within('.input') do
            fill_in 'Body', with: 'Some text'
            click_on 'Create a comment'
            wait_for_ajax
          end
        end
        expect(current_path).to eq question_path(question)
        within("#answer_#{answer.id}_list") do                   
          expect(page).to have_content "Some text"
          expect(page).to have_content user.name
        end
      end
    end

    context 'Invalid attributes', js: true do
      scenario 'Can not create a comment', js: true  do
        within("#answer_#{answer.id}_comments") do
          within('.input') do          
            click_on 'Create a comment'
            wait_for_ajax
          end
        end
        expect(current_path).to eq question_path(question)
        within("#answer_#{answer.id}_list") do          
          expect(page).to_not have_content user.name
        end
        within("#answer_#{answer.id}_comments") do
          within(".comments_error") do
            expect(page).to have_content "Body can't be blank"
          end
        end
      end
    end
  end

   context "Non authenticated user" do
    
    scenario 'Can not commente a question' do
      visit question_path(question)
      within("#answer_#{answer.id}") do        
        expect(page).to_not have_link "Create a comment"
      end
    end
  end

  
end