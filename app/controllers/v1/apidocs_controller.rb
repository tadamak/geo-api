class V1::ApidocsController < ApplicationController
  skip_before_action :check_access_token
  skip_after_action :update_access_token_count

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
      externalDocs do
        key :description, 'About'
        key :url, '/addresses/about'
      end
    end
    tag do
      key :name, 'Mesh'
      key :description, '地域メッシュAPI'
      externalDocs do
        key :description, 'About'
        key :url, '/meshes/about'
      end
    end
    tag do
      key :name, 'Analytics'
      key :description, '解析API'
    end
    tag do
      key :name, 'Statistics'
      key :description, '統計API'
    end
    key :schemes, ['https', 'http']
    key :host, 'api.geo.qazsato.com'
    key :basePath, '/v1'
    key :consumes, ['application/json']
    key :produces, ['application/json']
    security_definition :access_token do
      key :type, :apiKey
      key :name, :access_token
      key :in, :query
    end
  end

  SWAGGERED_CLASSES = [
    Address,
    Mesh,
    GeoJson,
    TopoJson,
    Common::Error,
    V1::AddressesController,
    V1::MeshesController,
    V1::Analytics::AddressesController,
    V1::Statistics::AddressesController,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
