class Month
  attr_accessor :day, :week
  def initialize
    @week = 0
    @day = 0
  end

  def get_day
    @day = (@day%31)+1
  end

  def today
    @day
  end
end
