class V1::MeshesController < ApplicationController
  include Swagger::MeshesApi

  before_action :validate_index_params, only: [:index]
  before_action :validate_search_params, only: [:search]
  before_action :validate_shapes_params, only: [:shapes]

  def index
    meshes = Mesh.where(code: params[:codes].split(','))
    render json: meshes
  end

  def search
    search_level = get_search_level # 一階層下の地域メッシュレベルを取得
    meshes = Mesh.where(level: search_level)
    meshes = meshes.where('code LIKE ?', "#{@mesh.code}%") if @mesh.present?

    offset = get_offset
    limit = get_limit
    total = meshes.count
    meshes = meshes.offset(offset).limit(limit)

    response.headers['X-Total-Count'] = total
    render json: meshes
  end

  def shapes
    codes = params[:codes].split(',')
    geojsons = Mesh.geojsons(codes)
    render json: geojsons
  end

  private

  def validate_index_params
    codes = params[:codes]&.split(',')
    if codes.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'codes の指定が必要です。')
    elsif codes.length > Constants::MAX_LIMIT
      return render_400(ErrorCode::INVALID_PARAM, "codes の指定数が最大値(#{Constants::MAX_LIMIT}件)を超えています。")
    end
  end

  def validate_search_params
    limit = params[:limit].to_i
    offset = params[:offset].to_i
    code = params[:code]
    if limit < 0
      return render_400(ErrorCode::INVALID_PARAM, "limit には正の整数を指定してください。")
    end
    if limit > Constants::MAX_LIMIT
      return render_400(ErrorCode::INVALID_PARAM, "limit の指定数が最大値(#{Constants::MAX_LIMIT}件)を超えています。")
    end
    if offset < 0
      return render_400(ErrorCode::INVALID_PARAM, "offset には正の整数を指定してください。")
    end
    if code.present?
      @mesh = Mesh.find_by(code: code)
      if @mesh.nil?
        return render_400(ErrorCode::INVALID_PARAM, "存在しない地域メッシュコードを指定しています。")
      end
    end
  end

  def validate_shapes_params
    codes = params[:codes]&.split(',')
    if codes.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'codes の指定が必要です。')
    elsif codes.length > Constants::MAX_LIMIT
      return render_400(ErrorCode::INVALID_PARAM, "codes の指定数が最大値(#{Constants::MAX_LIMIT}件)を超えています。")
    end
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
