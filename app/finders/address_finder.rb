class AddressFinder
  include ActiveModel::Model

  ATTRS = %i[name level code parent_code location radius].freeze

  MIN_RADIUS = 0

  attr_accessor(*ATTRS)

  validates :level,
    inclusion: { in: Address::LEVEL.values },
    allow_blank: true
  validates :location,
    format: { with: /\d+(\.\d*)?,\d+(\.\d*)?/, message: "はカンマ区切りで緯度,経度の順で指定してください。" },
    allow_blank: true
  validates :radius,
    numericality: {
      greater_than_or_equal_to: MIN_RADIUS, less_than_or_equal_to: Constants::MAX_RADIUS,
    message: "は#{MIN_RADIUS}-#{Constants::MAX_RADIUS}の間で指定してください。" },
    allow_blank: true

  def initialize(attributes = {})
    super
    radius ||= Constants::DEFAULT_RADIUS
  end

  def execute
    raise ArgumentError, errors.full_messages.first unless valid?

    addrs = Address.all
    addrs = by_name(addrs) if name
    addrs = by_level(addrs) if level
    addrs = by_codes(addrs) if codes
    addrs = by_parent_code(addrs) if parent_code
    addrs = by_location(addrs) if location
    addrs
  end

  def distance
    return nil unless location

    "ST_DistanceSphere(ST_GeomFromText('POINT(#{location.lng} #{location.lat})', 4326), ST_GeomFromText(CONCAT('POINT(', longitude, ' ', latitude, ')'), 4326))"
  end

  private

  def latlng
    return nil if location.blank?

    @_latlng ||= LatLng.from_str(location)
  rescue
    nil
  end

  def by_name(addrs)
    keyword = "%#{sanitize_sql_like(name)}%"
    addrs.where("name LIKE ? OR kana LIKE ?", keyword, keyword)
  end

  def by_level(addrs)
    addrs.where(level: level)
  end

  def by_codes(addrs)
    addrs.where(code: codes.split(",").map(&:strip))
  end

  def by_parent_code(addrs)
    addrs.where("code LIKE ?", "#{sanitize_sql_like(parent_code)}%")
  end

  def by_location(addrs)
    addrs.where("#{distance} <= #{radius}")
  end
end
