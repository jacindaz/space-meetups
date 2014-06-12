class Member < ActiveRecord::Base
  #add numericality later, id should be less than greatest ID #
  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :meetup_id, presence: true, numericality: { only_integer: true }

  validates_uniqueness_of :user_id, scope: :meetup_id, :message => "You are already a member!"

  belongs_to :meetup
  belongs_to :user
end
