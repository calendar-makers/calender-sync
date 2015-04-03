class Event < ActiveRecord::Base
  has_many :guests, through: :registrations

  has_attached_file :image, styles: {small: "150x100", medium: "300x200", large: "450,300" }, :url => "/assets/:id/:style/:basename.:extension", :path => ":rails_root/public/assets/:id/:style/:basename.:extension"

  #validates_attachment_presence :image
  #validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/jpg']

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
