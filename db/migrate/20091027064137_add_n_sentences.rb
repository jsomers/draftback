class AddNSentences < ActiveRecord::Migration
  def self.up
    add_column :reviews, :n_sentences, :string
  end

  def self.down
    remove_column :reviews, :n_sentences
  end
end
