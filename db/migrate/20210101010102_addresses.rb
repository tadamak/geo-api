class Addresses < ActiveRecord::Migration[6.1]
  def change
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
  end
end
