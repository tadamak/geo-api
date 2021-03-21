class V1::Statistics::AddressesController < ApplicationController
  include Swagger::StatisticsApi

  before_action :validate_page_params, only: [:populations]
  before_action :validate_population_params, only: [:populations]
  before_action :get_populations, only: [:populations]

  def populations
    response.headers['X-Total-Count'] = @total
    render json: @populations
  end

  private

  def validate_population_params
    enable_sort_keys = ['address_code', 'address_level', 'total']
    sort = params[:sort]
    address_level = params[:address_level]
    if sort.present? && !is_enable_sort_key?(enable_sort_keys)
      return render_400(ErrorCode::INVALID_PARAM, 'sort の指定が誤っています。')
    end
    if address_level.present? && !Address::LEVEL.values.include?(address_level.to_i)
      return render_400(ErrorCode::INVALID_PARAM, 'address_level の指定が誤っています。')
    end
  end

  def get_populations
    # 検索条件
    address_level = params[:address_level]
    address_codes = params[:address_code]
    parent_address_code = params[:parent_address_code]
    sort = get_sort || [address_code: :asc]
    limit = get_limit
    offset = get_offset

    # 検索条件設定
    populations = AddressPopulation
    populations = populations.where(address_level: address_level) if address_level.present?
    populations = populations.where(address_code: address_codes.split(',')) if address_codes.present?
    populations = populations.where('address_code LIKE ?', "#{parent_address_code}%") if parent_address_code.present?

    # 合計件数取得
    @total = populations.count

    # 取得範囲設定
    populations = populations.order(sort).offset(offset).limit(limit)

    @populations =populations
  end
end
