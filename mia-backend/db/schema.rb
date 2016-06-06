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

ActiveRecord::Schema.define(version: 20160413214051) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "motif_ancestors", force: :cascade do |t|
    t.integer  "motif_id"
    t.integer  "ancestor_id"
    t.integer  "distance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "motif_ancestors", ["ancestor_id"], name: "index_motif_ancestors_on_ancestor_id", using: :btree
  add_index "motif_ancestors", ["motif_id"], name: "index_motif_ancestors_on_motif_id", using: :btree

  create_table "motifs", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "image",           limit: 255
    t.string   "icon",            limit: 255
    t.integer  "video_upload_id"
    t.string   "ancestry"
  end

  add_index "motifs", ["ancestry"], name: "index_motifs_on_ancestry", using: :btree
  add_index "motifs", ["owner_id"], name: "index_motifs_on_owner_id", using: :btree
  add_index "motifs", ["video_upload_id"], name: "index_motifs_on_video_upload_id", using: :btree

  create_table "related_motifs", force: :cascade do |t|
    t.integer  "motif1_id"
    t.integer  "motif2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "related_motifs", ["motif1_id"], name: "index_related_motifs_on_motif1_id", using: :btree
  add_index "related_motifs", ["motif2_id"], name: "index_related_motifs_on_motif2_id", using: :btree

  create_table "temp_uploads", force: :cascade do |t|
    t.string   "upload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transcode_jobs", force: :cascade do |t|
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "video_upload_id",               null: false
    t.string   "telestream_job_id",             null: false
    t.integer  "progress",          default: 0, null: false
    t.string   "profile",                       null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "password_digest",        limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.string   "avatar"
    t.boolean  "admin",                  default: false, null: false
    t.string   "api_key"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "video_motifs", force: :cascade do |t|
    t.integer  "video_id"
    t.integer  "motif_id"
    t.text     "description"
    t.integer  "start_time_ms"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.integer  "end_time_ms"
  end

  add_index "video_motifs", ["motif_id"], name: "index_video_motifs_on_motif_id", using: :btree
  add_index "video_motifs", ["owner_id"], name: "index_video_motifs_on_owner_id", using: :btree
  add_index "video_motifs", ["video_id"], name: "index_video_motifs_on_video_id", using: :btree

  create_table "video_uploads", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "webm_video_url"
    t.string   "mp4_video_url"
    t.string   "status",         default: "Submitted"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration_ms"
    t.string   "telestream_id"
  end

  add_index "video_uploads", ["telestream_id"], name: "index_video_uploads_on_telestream_id", using: :btree
  add_index "video_uploads", ["user_id"], name: "index_video_uploads_on_user_id", using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.text     "description"
    t.string   "external_id",       limit: 255
    t.string   "type",              limit: 255
    t.string   "external_url",      limit: 255
    t.boolean  "published",                     default: false
    t.integer  "duration_ms"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_default", limit: 255
    t.string   "thumbnail_medium",  limit: 255
    t.string   "thumbnail_high",    limit: 255
    t.text     "transcript"
    t.string   "director",          limit: 255
    t.string   "production",        limit: 255
    t.string   "fx",                limit: 255
    t.string   "client",            limit: 255
    t.string   "industry",          limit: 255
    t.string   "year",              limit: 255
    t.string   "location",          limit: 255
    t.integer  "owner_id"
    t.integer  "video_upload_id"
  end

  add_index "videos", ["owner_id"], name: "index_videos_on_owner_id", using: :btree
  add_index "videos", ["video_upload_id"], name: "index_videos_on_video_upload_id", using: :btree

  add_foreign_key "motifs", "video_uploads"
  add_foreign_key "videos", "video_uploads"
end
