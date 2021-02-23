class Address < ApplicationRecord
  include Swagger::AddressSchema

  # 住所階層
  LEVEL = {
    PREF:  1,
    CITY:  2,
    TOWN:  3
  }

  # 住所コード桁数
  CODE_DIGIT = {
    PREF: 2,
    CITY: 5,
    TOWN: 11
  }

  def location
    {
      lat: latitude,
      lng: longitude
    }
  end

  def codes
    codes = []
    codes << code[0, CODE_DIGIT[:PREF]]
    codes << code[0, CODE_DIGIT[:CITY]]  if code.length >= CODE_DIGIT[:CITY]
    codes << code[0, CODE_DIGIT[:TOWN]]  if code.length >= CODE_DIGIT[:TOWN]
    codes
  end

  def details
    details = []
    level.times do |i|
      l = i + 1
      details << {
        code: code_by_level(l),
        name: name_by_level(l),
        kana: kana_by_level(l),
        level: l
      }
    end
    details
  end

  def self.code_by_level(code, level)
    case level
    when LEVEL[:PREF] then
      code = code[0, CODE_DIGIT[:PREF]]
    when LEVEL[:CITY] then
      code = code[0, CODE_DIGIT[:CITY]]
    when LEVEL[:TOWN] then
      code = code[0, CODE_DIGIT[:TOWN]]
    end
    code
  end

  private

  def code_by_level(level)
    case level
    when LEVEL[:PREF] then
      c = code[0, CODE_DIGIT[:PREF]]
    when LEVEL[:CITY] then
      c = code[0, CODE_DIGIT[:CITY]]
    when LEVEL[:TOWN] then
      c = code[0, CODE_DIGIT[:TOWN]]
    end
    c
  end

  def name_by_level(level)
    case level
    when LEVEL[:PREF] then
      n = pref_name
    when LEVEL[:CITY] then
      n = city_name
    when LEVEL[:TOWN] then
      n = town_name
    end
    n
  end

  def kana_by_level(level)
    case level
    when LEVEL[:PREF] then
      n = pref_kana
    when LEVEL[:CITY] then
      n = city_kana
    when LEVEL[:TOWN] then
      n = nil
    end
    n
  end
end
