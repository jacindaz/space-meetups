class Member < ActiveRecord::Base
  #add numericality later, id should be less than greatest ID #
  validates :user_id, presence: true
  validates :meetup_id, presence: true

  belongs_to :meetups
  belongs_to :user
end
