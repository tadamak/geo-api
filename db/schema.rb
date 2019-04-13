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

ActiveRecord::Schema.define(version: 0) do

# Could not dump table "addresses" because of following StandardError
#   Unknown type 'geometry' for column 'coordinate'

  create_table "blocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "pref_name", limit: 4, default: "", null: false
    t.string "city_name", limit: 20, default: "", null: false
    t.string "town_name", limit: 20, default: "", null: false
    t.string "alias_name", limit: 20, default: "", null: false
    t.string "block_code", limit: 20, default: "", null: false
    t.integer "coord_sys_no", limit: 1, default: 0, null: false
    t.float "coord_x", limit: 53, default: 0.0, null: false
    t.float "coord_y", limit: 53, default: 0.0, null: false
    t.float "lat", limit: 53, default: 0.0, null: false
    t.float "lon", limit: 53, default: 0.0, null: false
    t.string "flag_disp_addr", limit: 1, default: "0", null: false
    t.string "flag_main", limit: 1, default: "0", null: false
    t.string "flag_before_upd", limit: 1, default: "0", null: false
    t.string "flag_after_upd", limit: 1, default: "0", null: false
    t.string "alias_code", limit: 4, default: "", null: false
  end

# Could not dump table "geo_addresses" because of following StandardError
#   Unknown type 'geometry' for column 'polygon'

# Could not dump table "test_geo_addresses" because of following StandardError
#   Unknown type 'geometry' for column 'polygon'

  create_table "towns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "pref_code", limit: 2, default: "", null: false
    t.string "pref_name", limit: 4, default: "", null: false
    t.string "city_code", limit: 5, default: "", null: false
    t.string "city_name", limit: 20, default: "", null: false
    t.string "town_code", limit: 12, default: "", null: false
    t.string "town_name", limit: 20, default: "", null: false
    t.float "lat", limit: 53, default: 0.0, null: false
    t.float "lon", limit: 53, default: 0.0, null: false
    t.string "org_res_code", limit: 1, default: "", null: false
    t.string "town_div_code", limit: 1, default: "", null: false
  end

end
