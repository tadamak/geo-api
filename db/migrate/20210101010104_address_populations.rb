class AddressPopulations < ActiveRecord::Migration[6.1]
  def change
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

    add_foreign_key "address_populations", "addresses", column: "address_code", primary_key: "code", name: "address_populations_address_code_fkey"
  end
end