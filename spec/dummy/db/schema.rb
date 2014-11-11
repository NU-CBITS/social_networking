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

ActiveRecord::Schema.define(version: 20141106104713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "participants", force: true do |t|
    t.string "email"
    t.string "phone_number"
    t.string "contact_status"
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
    t.date     "due_on"
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

  add_index "social_networking_likes", ["participant_id", "item_id", "item_type"], name: "one_like_per_item", unique: true, using: :btree

  create_table "social_networking_nudges", force: true do |t|
    t.integer  "initiator_id", null: false
    t.integer  "recipient_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networking_on_the_mind_statements", force: true do |t|
    t.text     "description",    null: false
    t.integer  "participant_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networking_profile_answers", force: true do |t|
    t.integer  "social_networking_profile_question_id", null: false
    t.integer  "order"
    t.string   "answer_text",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "social_networking_profile_id"
  end

  add_index "social_networking_profile_answers", ["social_networking_profile_id", "social_networking_profile_question_id"], name: "profile_answers_unique", unique: true, using: :btree

  create_table "social_networking_profile_questions", force: true do |t|
    t.string   "question_text", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networking_profiles", force: true do |t|
    t.integer  "participant_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_name"
    t.boolean  "active"
  end

  create_table "social_networking_shared_items", force: true do |t|
    t.integer  "item_id",                    null: false
    t.string   "item_type",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_public",   default: true, null: false
    t.string   "action_type", default: "",   null: false
    t.string   "item_label"
  end

end
