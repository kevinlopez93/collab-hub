# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_16_035819) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "boards", force: :cascade do |t|
    t.string "name"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.index ["created_by_id"], name: "index_boards_on_created_by_id"
    t.index ["project_id"], name: "index_boards_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id", null: false
    t.index ["created_by_id"], name: "index_projects_on_created_by_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.string "remote_id"
    t.string "node_id"
    t.string "name"
    t.string "full_name"
    t.boolean "private"
    t.string "owner_login"
    t.text "description"
    t.string "url_api"
    t.string "url_html"
    t.datetime "remote_created_at"
    t.datetime "remote_updated_at"
    t.string "visibility"
    t.string "language"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["project_id"], name: "index_repositories_on_project_id"
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "board_id", null: false
    t.bigint "creator_id", null: false
    t.string "workflow_status", default: "todo"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_tasks_on_board_id"
    t.index ["creator_id"], name: "index_tasks_on_creator_id"
  end

  create_table "user_tasks", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_user_tasks_on_task_id"
    t.index ["user_id"], name: "index_user_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.uuid "token"
    t.jsonb "github_credentials", default: {}
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "boards", "projects"
  add_foreign_key "boards", "users", column: "created_by_id"
  add_foreign_key "projects", "users", column: "created_by_id"
  add_foreign_key "repositories", "projects"
  add_foreign_key "repositories", "users"
  add_foreign_key "tasks", "boards"
  add_foreign_key "tasks", "users", column: "creator_id"
  add_foreign_key "user_tasks", "tasks"
  add_foreign_key "user_tasks", "users"
end
