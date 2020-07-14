json.array! @counts_by_mesh_code do |count_by_mesh_code|
  json.set! :mesh do
    json.partial! 'v1/meshes/mesh', mesh: count_by_mesh_code[:mesh]
  end
  json.count count_by_mesh_code[:count]
end
