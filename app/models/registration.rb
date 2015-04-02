class Registration < ActiveRecord::Base
  belongs_to :event
  belongs_to :guest


  def is_updated?(latest_update)
    updated < latest_update
  end


end
