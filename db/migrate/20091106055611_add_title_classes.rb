class AddTitleClasses < ActiveRecord::Migration
  def self.up
    add_column :reviews, :title_classes, :string
  end

  def self.down
    remove_column :reviews, :title_classes
  end
end
