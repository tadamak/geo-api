json.code @address.code
json.name @address.name
json.level @address.level
json.set! :coordinate do
  json.latitude @address.lat
  json.longitude @address.lng
end
