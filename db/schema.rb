# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091106055611) do

  create_table "drafts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.text     "title",      :default => ""
    t.text     "content",    :default => ""
    t.string   "public_url"
    t.string   "email"
    t.integer  "user_id"
  end

  create_table "reviews", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "draft_id"
    t.text     "content"
    t.string   "signature"
    t.string   "n_sentences"
    t.text     "general_comments"
    t.string   "title_classes"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

end
