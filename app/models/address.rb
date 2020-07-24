class Address < ApplicationRecord
  include Swagger::AddressSchema

  attr_accessor :lat, :lng

  # 住所階層
  LEVEL = {
    PREF:  1,
    CITY:  2,
    TOWN:  3,
    BLOCK: 4
  }

  # 住所コード桁数
  CODE_DIGIT = {
    PREF: 2,
    CITY: 5,
    TOWN: 12,
    BLOCK: 20
  }

  default_scope { select('*, X(point) as lng, Y(point) as lat') }

  def lat
    self.attributes['lat']
  end

  def lng
    self.attributes['lng']
  end

  def codes
    codes = []
    codes << code[0, CODE_DIGIT[:PREF]]
    codes << code[0, CODE_DIGIT[:CITY]]  if code.length >= CODE_DIGIT[:CITY]
    codes << code[0, CODE_DIGIT[:TOWN]]  if code.length >= CODE_DIGIT[:TOWN]
    codes << code[0, CODE_DIGIT[:BLOCK]] if code.length >= CODE_DIGIT[:BLOCK]
    codes
  end

  def details
    addresses = Address.where(code: self.codes).order(level: :asc)
    details = []
    addresses.each_with_index do |address, i|
      name = address.name
      # フルの住所名称から直前のレベルの住所名を除く (ex. "東京都墨田区"を"墨田区"に置換)
      name = name.sub(/^#{addresses[i - 1].name}/, '') unless i.zero?
      details << {
        code: address.code,
        name: name,
        level: address.level
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
    when LEVEL[:BLOCK] then
      code = code[0, CODE_DIGIT[:BLOCK]]
    end
    code
  end
end
