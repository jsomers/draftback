class CreateDrafts < ActiveRecord::Migration
  def self.up
    create_table :drafts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :drafts
  end
end
