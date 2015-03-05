class CreateSiteIterations < ActiveRecord::Migration
  def self.up
    create_table :site_iterations do |t|
      t.string :iteration_number
      t.string :iteration_title
      t.text :iteration_description
      t.datetime :publish_datetime
      t.integer :referential_post_id
    end

    add_attachment :site_iterations, :screenshot
  end

  def self.down
    remove_attachment :site_iterations, :screenshot

    drop_table :site_iterations
  end
end
