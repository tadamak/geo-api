json.items do
  json.array! @addresses do |address|
    json.partial! address
  end
end
json.partial! 'count', limit: @limit, offset: @offset, total: @total
