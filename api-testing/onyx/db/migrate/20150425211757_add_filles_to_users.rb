class AddFillesToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :fille, index: true, foreign_key: true
  end
end
