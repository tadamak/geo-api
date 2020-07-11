json.array! @counts_by_address_code do |count_by_address_code|
  json.set! :address do
    json.partial! 'v1/addresses/address', address: count_by_address_code[:address]
  end
  json.count count_by_address_code[:count]
end
