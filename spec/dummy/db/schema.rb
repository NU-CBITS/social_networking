# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140904201719) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "participants", force: true do |t|
    t.string "email"
  end

  create_table "social_networking_comments", force: true do |t|
    t.integer  "participant_id", null: false
    t.string   "text",           null: false
    t.integer  "item_id",        null: false
    t.string   "item_type",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networking_goals", force: true do |t|
    t.string   "description",                    null: false
    t.integer  "participant_id",                 null: false
    t.boolean  "is_completed",   default: false, null: false
    t.boolean  "is_deleted",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networking_likes", force: true do |t|
    t.integer  "participant_id", null: false
    t.integer  "item_id",        null: false
    t.string   "item_type",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networking_nudges", force: true do |t|
    t.integer  "initiator_id", null: false
    t.integer  "recipient_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
