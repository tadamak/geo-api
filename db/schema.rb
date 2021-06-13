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

ActiveRecord::Schema.define(version: 2021_01_01_010108) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "address_populations", comment: "住所人口テーブル", force: :cascade do |t|
    t.string "address_code", limit: 11, null: false, comment: "住所コード"
    t.integer "address_level", limit: 2, null: false, comment: "住所レベル (1: 都道府県, 2: 市区町村, 3: 大字・町名, 4: 字・丁目)"
    t.integer "total", default: 0, null: false, comment: "合計人数"
    t.integer "male_age_0_4", default: 0, null: false, comment: "男性0~4歳"
    t.integer "male_age_5_9", default: 0, null: false, comment: "男性5~9歳"
    t.integer "male_age_10_14", default: 0, null: false, comment: "男性10~14歳"
    t.integer "male_age_15_19", default: 0, null: false, comment: "男性15~19歳"
    t.integer "male_age_20_24", default: 0, null: false, comment: "男性20~24歳"
    t.integer "male_age_25_29", default: 0, null: false, comment: "男性25~29歳"
    t.integer "male_age_30_34", default: 0, null: false, comment: "男性30~34歳"
    t.integer "male_age_35_39", default: 0, null: false, comment: "男性35~39歳"
    t.integer "male_age_40_44", default: 0, null: false, comment: "男性40~44歳"
    t.integer "male_age_45_49", default: 0, null: false, comment: "男性45~49歳"
    t.integer "male_age_50_54", default: 0, null: false, comment: "男性50~54歳"
    t.integer "male_age_55_59", default: 0, null: false, comment: "男性55~59歳"
    t.integer "male_age_60_64", default: 0, null: false, comment: "男性60~64歳"
    t.integer "male_age_65_69", default: 0, null: false, comment: "男性65~69歳"
    t.integer "male_age_70_74", default: 0, null: false, comment: "男性70~74歳"
    t.integer "male_age_75", default: 0, null: false, comment: "男性75歳以上"
    t.integer "female_age_0_4", default: 0, null: false, comment: "女性0~4歳"
    t.integer "female_age_5_9", default: 0, null: false, comment: "女性5~9歳"
    t.integer "female_age_10_14", default: 0, null: false, comment: "女性10~14歳"
    t.integer "female_age_15_19", default: 0, null: false, comment: "女性15~19歳"
    t.integer "female_age_20_24", default: 0, null: false, comment: "女性20~24歳"
    t.integer "female_age_25_29", default: 0, null: false, comment: "女性25~29歳"
    t.integer "female_age_30_34", default: 0, null: false, comment: "女性30~34歳"
    t.integer "female_age_35_39", default: 0, null: false, comment: "女性35~39歳"
    t.integer "female_age_40_44", default: 0, null: false, comment: "女性40~44歳"
    t.integer "female_age_45_49", default: 0, null: false, comment: "女性45~49歳"
    t.integer "female_age_50_54", default: 0, null: false, comment: "女性50~54歳"
    t.integer "female_age_55_59", default: 0, null: false, comment: "女性55~59歳"
    t.integer "female_age_60_64", default: 0, null: false, comment: "女性60~64歳"
    t.integer "female_age_65_69", default: 0, null: false, comment: "女性65~69歳"
    t.integer "female_age_70_74", default: 0, null: false, comment: "女性70~74歳"
    t.integer "female_age_75", default: 0, null: false, comment: "女性75歳以上"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["address_code"], name: "idx_address_populations_address_code", unique: true
    t.index ["address_level"], name: "idx_address_populations_address_level"
    t.index ["total"], name: "idx_address_populations_total"
  end

  create_table "addresses", comment: "住所テーブル", force: :cascade do |t|
    t.string "code", limit: 11, null: false, comment: "住所コード"
    t.integer "level", limit: 2, null: false, comment: "住所レベル (1: 都道府県, 2: 市区町村, 3: 大字・町名, 4: 字・丁目)"
    t.string "name", limit: 128, null: false, comment: "住所名称"
    t.string "pref_name", limit: 16, null: false, comment: "都道府県名称"
    t.string "city_name", limit: 32, comment: "市区町村名称"
    t.string "town_name", limit: 32, comment: "大字・町名名称"
    t.string "chome_name", limit: 32, comment: "字・丁目名称"
    t.string "kana", limit: 128, null: false, comment: "住所読み仮名"
    t.string "pref_kana", limit: 16, null: false, comment: "都道府県読み仮名"
    t.string "city_kana", limit: 32, comment: "市区町村読み仮名"
    t.string "town_kana", limit: 32, comment: "大字・町名読み仮名"
    t.string "chome_kana", limit: 32, comment: "字・丁目読み仮名"
    t.float "latitude", null: false, comment: "緯度 (世界測地系の10進数表記)"
    t.float "longitude", null: false, comment: "経度 (世界測地系の10進数表記)"
    t.float "area", null: false, comment: "面積(㎡)"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "idx_addresses_code", unique: true
    t.index ["kana"], name: "idx_addresses_kana"
    t.index ["level"], name: "idx_addresses_level"
  end

  create_table "api_keys", comment: "APIキーテーブル", force: :cascade do |t|
    t.string "code", limit: 32, null: false, comment: "コード"
    t.string "http_referrer", limit: 64, comment: "許可するウェブサイト"
    t.string "ip_address", limit: 64, comment: "許可するサーバIPアドレス"
    t.integer "limit_per_hour", null: false, comment: "１時間あたりの利用上限"
    t.integer "count_per_hour", default: 0, null: false, comment: "１時間あたりの利用回数"
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "最終リクエスト時刻"
    t.string "memo", limit: 128, comment: "メモ"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "idx_api_keys_code", unique: true
  end

  create_table "geo_addresses", comment: "住所ポリゴンテーブル", force: :cascade do |t|
    t.string "address_code", limit: 11, null: false, comment: "住所コード"
    t.geometry "polygon", limit: {:srid=>4326, :type=>"multi_polygon"}, null: false, comment: "住所の行政界ポリゴン"
    t.integer "level", limit: 2, null: false, comment: "住所レベル (1: 都道府県, 2: 市区町村, 3: 大字・町名, 4: 字・丁目)"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["address_code"], name: "idx_geo_addresses_address_code", unique: true
    t.index ["level"], name: "idx_geo_addresses_level"
    t.index ["polygon"], name: "idx_geo_addresses_polygon", using: :spgist
  end

  create_table "railway_stations", comment: "鉄道駅テーブル", force: :cascade do |t|
    t.string "code", limit: 16, null: false, comment: "鉄道駅コード"
    t.string "name", limit: 64, null: false, comment: "鉄道駅名称"
    t.string "address_code", limit: 11, null: false, comment: "住所コード"
    t.float "latitude", null: false, comment: "緯度 (世界測地系の10進数表記)"
    t.float "longitude", null: false, comment: "経度 (世界測地系の10進数表記)"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["address_code"], name: "idx_railway_stations_address_code"
    t.index ["code"], name: "idx_railway_stations_code", unique: true
    t.index ["name"], name: "idx_railway_stations_name"
  end

  create_table "school_districts", comment: "学区テーブル", force: :cascade do |t|
    t.string "code", limit: 16, null: false, comment: "学区コード"
    t.string "address_code", limit: 11, null: false, comment: "住所コード"
    t.string "school_code", limit: 16, comment: "学校コード"
    t.integer "school_type", limit: 2, null: false, comment: "学校種別 (1: 小学校, 2: 中学校)"
    t.string "school_name", limit: 64, null: false, comment: "学校名称"
    t.string "school_address", limit: 64, null: false, comment: "学校住所"
    t.float "latitude", null: false, comment: "緯度 (世界測地系の10進数表記)"
    t.float "longitude", null: false, comment: "経度 (世界測地系の10進数表記)"
    t.geometry "polygon", limit: {:srid=>4326, :type=>"multi_polygon"}, null: false, comment: "学区ポリゴン"
    t.integer "year", limit: 2, null: false, comment: "年度"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["address_code"], name: "idx_school_districts_address_code"
    t.index ["code"], name: "idx_school_districts_code", unique: true
    t.index ["polygon"], name: "idx_school_districts_polygon", using: :spgist
    t.index ["school_code"], name: "idx_school_districts_school_code"
    t.index ["school_name"], name: "idx_school_districts_school_name"
    t.index ["school_type"], name: "idx_school_districts_school_type"
  end

  create_table "schools", comment: "学校テーブル", force: :cascade do |t|
    t.string "code", limit: 16, null: false, comment: "学校コード"
    t.string "name", limit: 64, null: false, comment: "学校名称"
    t.integer "school_type", limit: 2, null: false, comment: "学校種別 (1: 小学校, 2: 中学校, 3: 中等教育学校, 4: 高等学校, 5: 高等専門学校, 6: 短期大学, 7: 大学, 8: 特別支援学校)"
    t.integer "school_admin", limit: 2, null: false, comment: "学校管理 (1: 国, 2: 都道府県, 3: 市区町村, 4: 民間, 0: その他)"
    t.string "school_address", limit: 64, null: false, comment: "学校住所"
    t.string "address_code", limit: 11, null: false, comment: "住所コード"
    t.float "latitude", null: false, comment: "緯度 (世界測地系の10進数表記)"
    t.float "longitude", null: false, comment: "経度 (世界測地系の10進数表記)"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["address_code"], name: "idx_schools_address_code"
    t.index ["code"], name: "idx_schools_code", unique: true
    t.index ["name"], name: "idx_schools_name"
    t.index ["school_admin"], name: "idx_schools_school_admin"
    t.index ["school_type"], name: "idx_schools_school_type"
  end

  create_table "view_map_states", comment: "参照地図状態テーブル", force: :cascade do |t|
    t.string "code", limit: 32, null: false, comment: "コード"
    t.string "title", limit: 64, null: false, comment: "タイトル"
    t.string "description", limit: 256, comment: "ディスクリプション"
    t.integer "zoom", limit: 2, null: false, comment: "地図ズーム値"
    t.float "latitude", null: false, comment: "中心緯度 (世界測地系の10進数表記)"
    t.float "longitude", null: false, comment: "中心経度 (世界測地系の10進数表記)"
    t.integer "analysis_type", limit: 2, null: false, comment: "種別 (1: 住所, 2: 地域メッシュ, 3: ヒートマップ, 4: マーカークラスター)"
    t.integer "analysis_level", limit: 2, comment: "住所・地域メッシュレベル"
    t.json "locations", null: false, comment: "緯度経度の配列"
    t.integer "map_theme", limit: 2, comment: "地図テーマ (1: standard, 2: silver, 3: retro, 4: night, 5: dark, 6: aubergine, 7: satellite)"
    t.string "polygon_color", limit: 8, comment: "ポリゴンのカラーコード"
    t.integer "count_range_from", comment: "絞り込み件数の開始値"
    t.integer "count_range_to", comment: "絞り込み件数の終了値"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "idx_view_map_states_code", unique: true
  end

  add_foreign_key "address_populations", "addresses", column: "address_code", primary_key: "code", name: "address_populations_address_code_fkey"
  add_foreign_key "geo_addresses", "addresses", column: "address_code", primary_key: "code", name: "geo_addresses_address_code_fkey"
  add_foreign_key "railway_stations", "addresses", column: "address_code", primary_key: "code", name: "railway_stations_address_code_fkey"
  add_foreign_key "school_districts", "addresses", column: "address_code", primary_key: "code", name: "school_districts_address_code_fkey"
  add_foreign_key "school_districts", "schools", column: "school_code", primary_key: "code", name: "school_districts_school_code_fkey"
  add_foreign_key "schools", "addresses", column: "address_code", primary_key: "code", name: "schools_address_code_fkey"
end
