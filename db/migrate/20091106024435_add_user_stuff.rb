class AddUserStuff < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :string
    add_column :drafts, :user_id, :integer
  end

  def self.down
    remove_column :users, :email
    remove_column :drafts, :user_id
  end
end
