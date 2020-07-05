json.code address.code
json.name address.name
json.level address.level
json.set! :location do
  json.lat address.lat
  json.lng address.lng
end
json.set! :addresses do
  json.array! address.addresses, :code, :name
end
