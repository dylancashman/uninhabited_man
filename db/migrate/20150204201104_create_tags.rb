class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :internal_symbol
      t.string :description

      t.timestamps
    end
  end
end
