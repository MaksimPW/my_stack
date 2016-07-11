FactoryGirl.define do
  sequence :body do |n|
   "MyAnswerText#{n}"
  end
  factory :answer do
    user
    question
    body           
  end
  factory :invalid_answer, class:'Answer' do
    body nil
  end
end
