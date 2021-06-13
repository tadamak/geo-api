class RailwayStations < ActiveRecord::Migration[6.1]
  def change
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

    add_foreign_key "railway_stations", "addresses", column: "address_code", primary_key: "code", name: "railway_stations_address_code_fkey"
  end
end