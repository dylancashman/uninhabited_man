class AddAttachmentToPosts < ActiveRecord::Migration
  def change
    add_attachment :posts, :title_image
  end
end
