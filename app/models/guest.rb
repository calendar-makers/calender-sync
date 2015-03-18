class Guest < ActiveRecord::Base
  has_many :events, through: :registrations

  def all_non_anon
    Guest.where(is_anon: false)
  end

  def all_anon
    Guest.where(is_anon: true)
  end
end
