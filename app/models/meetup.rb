class Meetup < ActiveRecord::Base
  validates :name, presence: true, :uniqueness => {:message => "Sorry, that meetup name has been used already."}
  validates :location, presence: true
  validates :description, presence: true

  validates_uniqueness_of :name
  validates_uniqueness_of :description

  has_many :members
end

