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

  def addresses
    addresses = Address.where(code: self.codes).order(level: :asc)
    converted_addresses = []
    addresses.each_with_index do |address, i|
      name = address.name
      # フルの住所名称から直前のレベルの住所名を除く (ex. "東京都墨田区"を"墨田区"に置換)
      name = name.sub(/^#{addresses[i - 1].name}/, '') unless i.zero?
      converted_addresses << {
        code: address.code,
        name: name
      }
    end
    converted_addresses
  end
end
