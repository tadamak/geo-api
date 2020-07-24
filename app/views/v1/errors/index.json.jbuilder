json.set! :error do
  json.code error_code[:code]
  json.type error_code[:type]
  json.message message
end