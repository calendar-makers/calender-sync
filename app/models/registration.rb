class Registration < ActiveRecord::Base
  belongs_to :event
  belongs_to :guest

  def needs_updating?(latest_update)
    updated < latest_update
  end
end
