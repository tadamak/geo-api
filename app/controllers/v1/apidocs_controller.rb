class V1::ApidocsController < ApplicationController
  skip_before_action :check_api_key

  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.3.1'
      key :title, 'Geo API'
      key :description, 'Geo API (地理情報)のドキュメントです。<br>住所や統計情報を元にした GIS 分析をおこなうための API を提供しています。'
    end
    externalDocs do
      key :description, "Geo API の共通仕様について"
      key :url, "https://docs.geo.qazsato.com/about"
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
      key :name, 'Analytics'
      key :description, '解析API'
    end
    tag do
      key :name, 'Statistics'
      key :description, '統計API'
    end
    tag do
      key :name, 'Railway'
      key :description, '鉄道API'
    end
    tag do
      key :name, 'School'
      key :description, '学校API'
    end
    tag do
      key :name, 'School District'
      key :description, '学区API'
    end
    key :schemes, ['https']
    key :host, 'api.geo.qazsato.com'
    key :basePath, '/v1'
    key :consumes, ['application/json']
    key :produces, ['application/json']
    security_definition :api_key do
      key :type, :apiKey
      key :name, :api_key
      key :in, :query
    end
  end

  SWAGGERED_CLASSES = [
    Address,
    AddressPopulation,
    RailwayStation,
    RailwayLine,
    School,
    SchoolDistrict,
    GeoJson,
    Common::Error,
    V1::AddressesController,
    V1::Analytics::AddressesController,
    V1::Railways::StationsController,
    V1::Statistics::AddressesController,
    V1::SchoolsController,
    V1::SchoolDistrictsController,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
