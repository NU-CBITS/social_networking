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

ActiveRecord::Schema.define(version: 20150317180057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "participant_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "arms", force: :cascade do |t|
    t.string  "title",     default: "",    null: false
    t.boolean "is_social", default: false, null: false
    t.boolean "has_woz",   default: false
  end

  create_table "participants", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.string "contact_preference"
    t.string "study_id"
  end

  create_table "social_networking_comments", force: :cascade do |t|
    t.integer  "participant_id", null: false
    t.string   "text",           null: false
    t.integer  "item_id",        null: false
    t.string   "item_type",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networking_goals", force: :cascade do |t|
    t.string   "description",                    null: false
    t.integer  "participant_id",                 null: false
    t.boolean  "is_deleted",     default: false, null: false
    t.date     "due_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
  end

  create_table "social_networking_likes", force: :cascade do |t|
    t.integer  "participant_id", null: false
    t.integer  "item_id",        null: false
    t.string   "item_type",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "social_networking_likes", ["participant_id", "item_id", "item_type"], name: "one_like_per_item", unique: true, using: :btree

  create_table "social_networking_nudges", force: :cascade do |t|
    t.integer  "initiator_id", null: false
    t.integer  "recipient_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networking_on_the_mind_statements", force: :cascade do |t|
    t.text     "description",    null: false
    t.integer  "participant_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networking_profile_answers", force: :cascade do |t|
    t.integer  "social_networking_profile_question_id", null: false
    t.integer  "order"
    t.string   "answer_text",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "social_networking_profile_id"
  end

  add_index "social_networking_profile_answers", ["social_networking_profile_id", "social_networking_profile_question_id"], name: "profile_answers_unique", unique: true, using: :btree

  create_table "social_networking_profile_questions", force: :cascade do |t|
    t.string   "question_text", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networking_profiles", force: :cascade do |t|
    t.integer  "participant_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_name"
    t.boolean  "active"
  end

  create_table "social_networking_shared_items", force: :cascade do |t|
    t.integer  "item_id",                       null: false
    t.string   "item_type",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_public",      default: true, null: false
    t.string   "action_type",    default: "",   null: false
    t.string   "item_label"
    t.integer  "participant_id"
  end

  add_index "social_networking_shared_items", ["participant_id"], name: "index_social_networking_shared_items_on_participant_id", using: :btree

  add_foreign_key "social_networking_comments", "participants", name: "fk_comments_participants"
  add_foreign_key "social_networking_goals", "participants", name: "fk_goals_participants"
  add_foreign_key "social_networking_likes", "participants", name: "fk_likes_participants"
  add_foreign_key "social_networking_nudges", "participants", column: "initiator_id", name: "fk_nudges_initiators"
  add_foreign_key "social_networking_nudges", "participants", column: "recipient_id", name: "fk_nudges_recipients"
  add_foreign_key "social_networking_on_the_mind_statements", "participants", name: "fk_on_the_mind_participants"
  add_foreign_key "social_networking_profile_answers", "social_networking_profile_questions", name: "fk_profile_answers_profile_questions"
  add_foreign_key "social_networking_profile_answers", "social_networking_profiles", name: "fk_profile_answers_profiles"
  add_foreign_key "social_networking_profiles", "participants", name: "fk_profiles_participants"
end
