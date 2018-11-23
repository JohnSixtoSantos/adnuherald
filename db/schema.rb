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

ActiveRecord::Schema.define(version: 201808121601010) do

  create_table "collections", force: :cascade do |t|
    t.string "collection_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "label_sets", force: :cascade do |t|
    t.integer "collection_id"
    t.integer "label_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label_set_name"
    t.decimal "percent"
  end

  create_table "labels", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "label"
    t.integer "label_set_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "message"
    t.boolean "is_read"
    t.string "message_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "summarization_results", force: :cascade do |t|
    t.string "root_word"
    t.float "b_value"
    t.string "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "collection_id"
  end

  create_table "topic_analysis_results", force: :cascade do |t|
    t.integer "num_topics"
    t.integer "num_words"
    t.integer "collection_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topic_words", force: :cascade do |t|
    t.string "word_text"
    t.integer "order_number"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.integer "topic_result_id"
    t.integer "topic_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.string "tweet_text"
    t.decimal "tweet_lat"
    t.decimal "tweet_lon"
    t.string "tweet_user"
    t.datetime "tweet_time"
    t.integer "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
