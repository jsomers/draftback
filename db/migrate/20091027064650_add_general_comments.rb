class AddGeneralComments < ActiveRecord::Migration
  def self.up
    add_column :reviews, :general_comments, :text
  end

  def self.down
    remove_column :reviews, :general_comments
  end
end
