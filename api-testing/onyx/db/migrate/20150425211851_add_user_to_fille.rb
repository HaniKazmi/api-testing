class AddUserToFille < ActiveRecord::Migration
  def change
    add_reference :filles, :user, index: true, foreign_key: true
  end
end
