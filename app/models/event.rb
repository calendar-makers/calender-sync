class Event < ActiveRecord::Base
  has_many :guests, through: :registrations

  scope :between, lambda {|start_time, end_time|
    {:conditions => ["? < start < ?", Event.format_date(start_time), Event.format_date(end_time)] }
  }

  def as_json(options = {})
  {
    :id => self.id,
    :title => self.title,
    :start => start.iso8601,
    :url => Rails.application.routes.url_helpers.event_path(id)
  }
  end

  def self.scoped(options=nil)
    options ? where(nil).apply_finder_options(options, true) : where(nil)
  end

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
