class GeoAddresses < ActiveRecord::Migration[6.1]
  def change
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

    add_foreign_key "geo_addresses", "addresses", column: "address_code", primary_key: "code", name: "geo_addresses_address_code_fkey"
  end
end