class V1::ApidocsController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Geo API 🌏'
      key :description, '空間情報検索API'
    end
    tag do
      key :name, 'Address'
      key :description, '住所API'
    end
    tag do
      key :name, 'Analysis'
      key :description, '解析API'
    end
    key :schemes, ['https', 'http']
    key :host, 'api.geo.qazsato.com'
    key :basePath, '/v1'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  SWAGGERED_CLASSES = [
    Address,
    GeoJson,
    V1::AddressesController,
    V1::Addresses::ShapesController,
    V1::Analyses::AddressesController,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
