class AddShortDescriptionToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :short_description, :text
  end
end
