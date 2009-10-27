class ReviewsBackend < ActiveRecord::Migration
  def self.up
    add_column :reviews, :draft_id, :integer
    add_column :reviews, :content, :text
    add_column :reviews, :signature, :string
    add_column :drafts, :email, :string
  end

  def self.down
    remove_column :reviews, :draft_id
    remove_column :reviews, :content
    remove_column :reviews, :signature
    remove_column :drafts, :email
  end
end
