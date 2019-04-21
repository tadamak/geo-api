class V1::ApidocsController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Geo API'
      key :description, '位置情報を利用した空間検索用API'
    end
    tag do
      key :name, 'address'
      key :description, '住所API'
    end
    key :schemes, ['https', 'http']
    key :host, 'geo.api.qazsato.com'
    key :basePath, '/v1'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  SWAGGERED_CLASSES = [
    AddressesController,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
