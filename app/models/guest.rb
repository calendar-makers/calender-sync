class Guest < ActiveRecord::Base
  has_many :registrations
  has_many :events, through: :registrations

  def self.check_if_fields_valid(arg1)
    result = {}
    result[:message] = []
    result[:value] = true
    arg1.each do |k, v|
      if v == nil || v == ''
        result[:value] = false
        result[:message].append k.to_s
      end
    end
    result
  end
end
