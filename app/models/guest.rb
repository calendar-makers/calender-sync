class Guest < ActiveRecord::Base
  has_many :events, through: :registrations
end
