class AddPaperclipToEvent < ActiveRecord::Migration
  def change
  	add_attachment :events, :image
  	"""
    adds:
    image_file_name       	The original filename of the image.
    image_content_type 		The mime type of the image.
    image_file_size 		The file size of the image.
    image_updated_at 		The last updated date of the image.
  	"""
  end
end
