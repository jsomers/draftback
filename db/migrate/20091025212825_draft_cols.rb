class DraftCols < ActiveRecord::Migration
  def self.up
    add_column :drafts, :url, :string
    add_column :drafts, :title, :text
    add_column :drafts, :content, :text
  end

  def self.down
    remove_column :drafts, :url
    remove_column :drafts, :title
    remove_column :drafts, :content
  end
end
