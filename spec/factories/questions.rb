FactoryGirl.define do
  factory :question do    
    sequence :title do |n|
      "MyString#{n}"
    end
    sequence :body do |n|
      "MyText#{n}"
    end
    user
    factory :question_with_answers do      
      transient do
        answers_count 2
      end
        
      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question )
      end
    end
  end
  factory :invalid_question, class: "Question" do
    title nil
    body nil    
  end
  
end
