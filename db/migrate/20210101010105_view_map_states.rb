class ViewMapStates < ActiveRecord::Migration[6.1]
  def change
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
  end
end