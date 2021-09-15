class LatLng < Struct.new(:lat, :lng, keyword_init: true)
  include ActiveModel::Validations

  validates :lat, presence: true, numericality: { greater_than: 20.0, less_than: 46.0 }
  validates :lng, presence: true, numericality: { greater_than: 122.55, less_than: 154.0 }

  def initialize(lat:, lng:)
    super
    raise ArgumentError, errors.full_messages.first unless valid?
  end

  def self.from_str(latlng)
    ll = latlng.split(",")
    new(lat: ll[0], lng: ll[1])
  end
end
