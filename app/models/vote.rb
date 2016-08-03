class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user  

  validates :user, :votable, :vote_field, presence: true 
  validates :user_id, uniqueness: { scope: :votable_id }
  validates :votable_id, uniqueness: { scope: :user_id }

end
