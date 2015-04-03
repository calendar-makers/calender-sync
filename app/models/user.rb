class User < ActiveRecord::Base
  has_many :registrations
  has_many :events, through: :registrations

  def self.fields_valid?(fields)
    fields.each do |k, v|
      if v == nil || v == ''
        return false
      end
    end
    true
  end
end
