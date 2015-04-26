class CreateFilles < ActiveRecord::Migration
  def change
    create_table :filles do |t|
      t.string :filename
      t.string :location
      t.integer :size

      t.timestamps null: false
    end
  end
end
