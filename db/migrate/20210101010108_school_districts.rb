class SchoolDistricts < ActiveRecord::Migration[6.1]
  def change
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

    add_foreign_key "school_districts", "addresses", column: "address_code", primary_key: "code", name: "school_districts_address_code_fkey"
    add_foreign_key "school_districts", "schools", column: "school_code", primary_key: "code", name: "school_districts_school_code_fkey"
  end
end