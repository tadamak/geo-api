class V1::MeshesController < ApplicationController
  include Swagger::MeshesApi

  before_action :validate_index_params, only: [:index]
  before_action :validate_search_params, only: [:search]
  before_action :validate_shapes_params, only: [:shapes]

  def index
    @meshes = Mesh.where(code: params[:codes].split(','))
  end

  def search
    search_level = get_search_level # 一階層下の地域メッシュレベルを取得
    @meshes = Mesh.where(level: search_level)
    @meshes = @meshes.where('code LIKE ?', "#{@mesh.code}%") if @mesh.present?

    offset = get_offset
    limit = get_limit
    total = @meshes.count
    @meshes = @meshes.offset(offset).limit(limit)

    response.headers['X-Total-Count'] = total
  end

  def shapes
    @geojsons = []
    codes = params[:codes].split(',')
    codes.each do |code|
      @geojsons << Mesh.geojson(code)
    end
  end

  private

  def validate_index_params
    codes = params[:codes]
    render status: :bad_request, json: { status: 400, message: 'Parameter(codes) is required.' } if codes.blank?
  end

  def validate_search_params
    code = params[:code]
    if code.present?
      @mesh = Mesh.find_by(code: code)
      render status: :bad_request, json: { status: 400, message: 'Invalid mesh code.' } if @mesh.nil?
    end
  end

  def validate_shapes_params
    codes = params[:codes]
    render status: :bad_request, json: { status: 400, message: 'Parameter(codes) is required.' } if codes.blank?
  end

  def get_search_level
    if @mesh.nil?
      Mesh::LEVEL[:FIRST]
    else
      @mesh.level + 1
    end
  end

  def get_limit
    limit = params[:limit].blank? ? Constants::DEFAULT_LIMIT : params[:limit].to_i
    limit = Constants::MAX_LIMIT if limit > Constants::MAX_LIMIT
    limit
  end

  def get_offset
    params[:offset].blank? ? Constants::DEFAULT_OFFSET : params[:offset].to_i
  end

end
