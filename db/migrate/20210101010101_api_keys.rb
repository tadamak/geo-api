class ApiKeys < ActiveRecord::Migration[6.1]
  def change
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
  end
end