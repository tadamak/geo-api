class Schools < ActiveRecord::Migration[6.1]
  def change
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

    add_foreign_key "schools", "addresses", column: "address_code", primary_key: "code", name: "schools_address_code_fkey"
  end
end