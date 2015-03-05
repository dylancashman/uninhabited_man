class AddSiteIterationIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :site_iteration_id, :integer
    add_index :posts, :site_iteration_id
  end
end
