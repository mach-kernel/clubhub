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

ActiveRecord::Schema.define(version: 20150403203436) do

  create_table "advisor", primary_key: "pid", force: :cascade do |t|
    t.string "phone", limit: 12
  end

  create_table "advisor_of", id: false, force: :cascade do |t|
    t.string  "pid",    limit: 30, default: "", null: false
    t.integer "clubid", limit: 4,  default: 0,  null: false
  end

  add_index "advisor_of", ["clubid"], name: "clubid", using: :btree

  create_table "club", primary_key: "clubid", force: :cascade do |t|
    t.string "cname", limit: 100
    t.string "descr", limit: 100
  end

  create_table "club_comment", primary_key: "comment_id", force: :cascade do |t|
    t.integer "clubid", limit: 4
  end

  add_index "club_comment", ["clubid"], name: "clubid", using: :btree

  create_table "club_topics", id: false, force: :cascade do |t|
    t.integer "clubid", limit: 4,   default: 0,  null: false
    t.string  "topic",  limit: 100, default: "", null: false
  end

  add_index "club_topics", ["topic"], name: "topic", using: :btree

  create_table "comment", primary_key: "comment_id", force: :cascade do |t|
    t.string  "commenter",   limit: 30
    t.string  "ctext",       limit: 255
    t.boolean "is_public_c", limit: 1
  end

  add_index "comment", ["commenter"], name: "commenter", using: :btree

  create_table "event", primary_key: "eid", force: :cascade do |t|
    t.string   "ename",        limit: 100
    t.string   "description",  limit: 255
    t.datetime "edatetime"
    t.string   "location",     limit: 100
    t.boolean  "is_public_e",  limit: 1
    t.integer  "sponsored_by", limit: 4
  end

  add_index "event", ["sponsored_by"], name: "sponsored_by", using: :btree

  create_table "event_comment", primary_key: "comment_id", force: :cascade do |t|
    t.integer "eid", limit: 4
  end

  add_index "event_comment", ["eid"], name: "eid", using: :btree

  create_table "interested_in", id: false, force: :cascade do |t|
    t.string "pid",   limit: 30,  default: "", null: false
    t.string "topic", limit: 100, default: "", null: false
  end

  add_index "interested_in", ["topic"], name: "topic", using: :btree

  create_table "keywords", primary_key: "topic", force: :cascade do |t|
  end

  create_table "member_of", id: false, force: :cascade do |t|
    t.string  "pid",    limit: 30, default: "", null: false
    t.integer "clubid", limit: 4,  default: 0,  null: false
  end

  add_index "member_of", ["clubid"], name: "clubid", using: :btree

  create_table "person", primary_key: "pid", force: :cascade do |t|
    t.string  "passwd",    limit: 32
    t.string  "fname",     limit: 50
    t.string  "lname",     limit: 100
    t.boolean "clubadmin", limit: 1
    t.boolean "superuser", limit: 1
  end

  create_table "role_in", id: false, force: :cascade do |t|
    t.string  "pid",    limit: 30, default: "", null: false
    t.integer "clubid", limit: 4,  default: 0,  null: false
    t.string  "role",   limit: 30, default: "", null: false
  end

  create_table "sign_up", id: false, force: :cascade do |t|
    t.string  "pid", limit: 30, default: "", null: false
    t.integer "eid", limit: 4,  default: 0,  null: false
  end

  add_index "sign_up", ["eid"], name: "eid", using: :btree

  create_table "student", primary_key: "pid", force: :cascade do |t|
    t.string "gender", limit: 10
    t.string "class",  limit: 20
  end

  add_foreign_key "advisor", "person", column: "pid", primary_key: "pid", name: "advisor_ibfk_1"
  add_foreign_key "advisor_of", "advisor", column: "pid", primary_key: "pid", name: "advisor_of_ibfk_1"
  add_foreign_key "advisor_of", "club", column: "clubid", primary_key: "clubid", name: "advisor_of_ibfk_2"
  add_foreign_key "club_comment", "club", column: "clubid", primary_key: "clubid", name: "club_comment_ibfk_2"
  add_foreign_key "club_comment", "comment", primary_key: "comment_id", name: "club_comment_ibfk_1"
  add_foreign_key "club_topics", "club", column: "clubid", primary_key: "clubid", name: "club_topics_ibfk_1"
  add_foreign_key "club_topics", "keywords", column: "topic", primary_key: "topic", name: "club_topics_ibfk_2"
  add_foreign_key "comment", "person", column: "commenter", primary_key: "pid", name: "comment_ibfk_1"
  add_foreign_key "event", "club", column: "sponsored_by", primary_key: "clubid", name: "event_ibfk_1"
  add_foreign_key "event_comment", "comment", primary_key: "comment_id", name: "event_comment_ibfk_1"
  add_foreign_key "event_comment", "event", column: "eid", primary_key: "eid", name: "event_comment_ibfk_2"
  add_foreign_key "interested_in", "keywords", column: "topic", primary_key: "topic", name: "interested_in_ibfk_2"
  add_foreign_key "interested_in", "person", column: "pid", primary_key: "pid", name: "interested_in_ibfk_1"
  add_foreign_key "member_of", "club", column: "clubid", primary_key: "clubid", name: "member_of_ibfk_2"
  add_foreign_key "member_of", "student", column: "pid", primary_key: "pid", name: "member_of_ibfk_1"
  add_foreign_key "role_in", "member_of", column: "clubid", primary_key: "clubid", name: "role_in_ibfk_1"
  add_foreign_key "role_in", "member_of", column: "pid", primary_key: "pid", name: "role_in_ibfk_1"
  add_foreign_key "sign_up", "event", column: "eid", primary_key: "eid", name: "sign_up_ibfk_2"
  add_foreign_key "sign_up", "person", column: "pid", primary_key: "pid", name: "sign_up_ibfk_1"
  add_foreign_key "student", "person", column: "pid", primary_key: "pid", name: "student_ibfk_1"
end
