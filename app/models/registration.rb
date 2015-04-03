class Registration < ActiveRecord::Base
  belongs_to :event
  belongs_to :guest
<<<<<<< HEAD


  def is_updated?(latest_update)
    updated < latest_update
  end


=======
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
end
