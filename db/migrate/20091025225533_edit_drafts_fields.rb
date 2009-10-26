class EditDraftsFields < ActiveRecord::Migration
  def self.up
    change_column :drafts, :title, :text, :default => ""
    change_column :drafts, :content, :text, :default => ""
    add_column :drafts, :public_url, :string
  end

  def self.down
    remove_column :drafts, :public_url
    change_column :drafts, :title, :text, :default => nil
    change_column :drafts, :content, :text, :default => nil
  end
end
