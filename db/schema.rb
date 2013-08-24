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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130603154014) do

  create_table "process_metrics", :force => true do |t|
    t.date     "date"
    t.datetime "time"
    t.integer  "proc_id"
    t.string   "proc_name"
    t.string   "proc_owner"
    t.decimal  "cpu"
    t.decimal  "mem"
    t.integer  "threads"
    t.decimal  "disk"
    t.integer  "server_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "process_metrics", ["server_id"], :name => "index_process_metrics_on_server_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "server_metrics", :force => true do |t|
    t.date     "date"
    t.datetime "time"
    t.decimal  "cpu"
    t.decimal  "mem"
    t.decimal  "net_in"
    t.decimal  "net_out"
    t.decimal  "disk"
    t.integer  "server_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "server_metrics", ["date"], :name => "index_server_metrics_on_date"
  add_index "server_metrics", ["server_id"], :name => "index_server_metrics_on_server_id"

  create_table "servers", :force => true do |t|
    t.string   "host_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "role_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
