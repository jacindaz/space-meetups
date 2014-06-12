class Meetup < ActiveRecord::Base
  validates :name, presence: true, :uniqueness => {:message => "Sorry, that meetup name has been used already.",
              case_sensitive: false }, length: { in: 10..100 }
  validates :location, presence: true, length: { minimum: 4 }
  validates :description, presence: true

  validates_uniqueness_of :name
  validates_uniqueness_of :description

  has_many :members
  has_many :users, through: :members
end

