require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :user_id } 
  it { should validate_presence_of :votable }
  it { should validate_presence_of :vote_field } 
  it { validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type])}
  it { should have_db_index [:user_id, :votable_id, :votable_type] }  

  describe 'up?' do
    let(:user){ create :user}
    let(:question){ create :question }
    let(:answer){ create :answer }
    let(:up_vote){ create :vote, votable: question, user: user, vote_field: 1 }    
    let(:down_vote){ create :vote, votable: question, user: user, vote_field: -1 }
    let(:up_answer_vote){ create :vote, votable: answer, user: user, vote_field: 1 } 
    let(:down_answer_vote){ create :vote, votable: answer, user: user, vote_field: -1 }

    it 'should return true when vote is +' do
      expect(up_vote.up?).to be_truthy
    end
    it 'should return true when vote is -' do
      expect(down_vote.up?).to be_falsy
    end
    it 'should return true when vote is +' do
      expect(up_answer_vote.up?).to be_truthy
    end
    it 'should return true when vote is -' do
      expect(down_answer_vote.up?).to be_falsy
    end
  end
  describe 'down?' do
    let(:user){ create :user}
    let(:question){ create :question }
    let(:answer){ create :answer }
    let(:up_vote){ create :vote, votable: question, user: user, vote_field: 1 } 
    let(:down_vote){ create :vote, votable: question, user: user, vote_field: -1 }
    let(:up_answer_vote){ create :vote, votable: answer, user: user, vote_field: 1 } 
    let(:down_answer_vote){ create :vote, votable: answer, user: user, vote_field: -1 }

    it 'should return true when vote is +' do
      expect(up_vote.down?).to be_falsy
    end
    it 'should return true when vote is -' do
      expect(down_vote.down?).to be_truthy      
    end
    it 'should return true when vote is +' do
      expect(up_answer_vote.down?).to be_falsy
    end
    it 'should return true when vote is -' do
      expect(down_answer_vote.down?).to be_truthy
    end
  end
  describe 'vote_permitted?' do
    let(:user){ create :user }
    let(:another_user){ create :user }
    let!(:question){ create :question, user: user }    
    let(:answer){ create :answer, user: user }    
    let(:another_vote){ create :vote, votable: question, user: another_user, vote_field: 1 }    
    let(:another_answer_vote){ create :vote, votable: answer, user: another_user, vote_field: 1 }   

    it 'return true if user voted before' do
      vvote = Vote.new(votable: question, user: user, vote_field: -1)
      expect(vvote.vote_permitted?).to be_truthy      
    end

    it 'return false if user does not vote before' do
      expect(another_vote.vote_permitted?).to be_falsy
    end

    it 'return true if user voted before' do
      vvote = Vote.new(votable: answer, user: user, vote_field: -1)
      expect(vvote.vote_permitted?).to be_truthy      
    end

    it 'return false if user does not vote before' do
      expect(another_answer_vote.vote_permitted?).to be_falsy
    end
  end
end