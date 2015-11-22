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

ActiveRecord::Schema.define(version: 20151122005404) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "name"
    t.string   "description",      limit: 1000
    t.string   "instructions",     limit: 1000
    t.integer  "teacher_user_id"
    t.string   "activity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "min_score"
    t.float    "max_score"
    t.float    "benchmark1_score"
    t.float    "benchmark2_score"
    t.string   "link"
  end

  create_table "activity_goal_reflections", force: true do |t|
    t.integer  "activity_goal_id"
    t.integer  "student_user_id"
    t.integer  "teacher_user_id"
    t.string   "reflection"
    t.datetime "reflection_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_goals", force: true do |t|
    t.integer  "classroom_activity_pairing_id"
    t.integer  "student_user_id"
    t.float    "score_goal"
    t.datetime "goal_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_levels", force: true do |t|
    t.integer  "activity_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation"
  end

  create_table "activity_tag_pairings", force: true do |t|
    t.integer  "activity_tag_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classroom_activity_pairings", force: true do |t|
    t.integer  "classroom_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden",       default: false, null: false
    t.integer  "sort_order"
    t.date     "due_date"
    t.boolean  "archived",     default: false, null: false
  end

  create_table "classroom_student_users", force: true do |t|
    t.integer  "student_user_id"
    t.integer  "classroom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classrooms", force: true do |t|
    t.integer  "teacher_user_id"
    t.string   "name"
    t.string   "description"
    t.string   "classroom_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_performance_verifications", force: true do |t|
    t.integer  "classroom_activity_pairing_id"
    t.integer  "student_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_performances", force: true do |t|
    t.integer  "student_user_id"
    t.integer  "classroom_activity_pairing_id"
    t.float    "scored_performance"
    t.boolean  "completed_performance"
    t.datetime "performance_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "verified"
    t.integer  "activity_level_id"
    t.string   "notes"
  end

  create_table "student_users", force: true do |t|
    t.string   "username",         limit: 64
    t.string   "display_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "salt"
    t.string   "password_digest"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "local_id"
    t.string   "gender"
    t.string   "salutation"
  end

  create_table "teacher_users", force: true do |t|
    t.string   "username",             limit: 64
    t.string   "display_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "salt"
    t.string   "password_digest"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default_view_student",            default: false, null: false
    t.string   "gender"
    t.string   "salutation"
  end

end
