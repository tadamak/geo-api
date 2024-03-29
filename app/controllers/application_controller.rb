class ApplicationController < ActionController::API
  before_action :check_api_key
  rescue_from Exception, with: :render_500

  def check_api_key
    if params[:api_key].blank?
      return render_401(ErrorCode::REQUIRED_PARAM, 'api_key の指定が必要です。')
    end

    api_key = ApiKey.find_by(code: params[:api_key])

    if api_key.nil?
      return render_401(ErrorCode::INVALID_PARAM, "誤った api_key を指定しています。")
    end

    unless api_key.is_available_url?(request.referer)
      return render_401(ErrorCode::INVALID_PARAM, "許可していないウェブサイト（HTTPリファラ）からのリクエストです。")
    end

    unless api_key.is_available_ip?(request.remote_ip)
      return render_401(ErrorCode::INVALID_PARAM, "許可していないウェブサーバ（IPアドレス）からのリクエストです。")
    end

    if api_key.is_exceed_request?
      set_rate_limit(api_key)
      return render_429(ErrorCode::RATE_LIMIT_EXCEEDED, "期間内のリクエスト上限 (#{api_key.limit_per_hour}件/時) を超えました。")
    end

    api_key.update_count
    set_rate_limit(api_key)
  end

  def render_400(error_code, message)
    render status: :bad_request, json: {
      error: Common::Error.new(error_code, message)
    }
  end

  def render_401(error_code, message)
    render status: :unauthorized, json: {
      error: Common::Error.new(error_code, message)
    }
  end

  def render_404
    error_code = ErrorCode::ROUTE_NOT_FOUND
    message = '存在しないパスを指定しています。'
    render status: :not_found, json: {
      error: Common::Error.new(error_code, message)
    }
  end

  def render_429(error_code, message)
    render status: :too_many_requests, json: {
      error: Common::Error.new(error_code, message)
    }
  end

  def render_500(e)
    logger.error "[Error] #{e.message}"
    logger.error e.backtrace.join("\n").indent(2)
    error_code = ErrorCode::INTERNAL_SERVER_ERROR
    message = 'システム内部で予期せぬエラーが発生しました。'
    render status: :internal_server_error, json: {
      error: Common::Error.new(error_code, message)
    }
  end

  private

  def set_rate_limit(api_key)
    limit, reset, remaining = api_key.get_rate_limit
    response.headers['X-Rate-Limit-Limit'] = limit
    response.headers['X-Rate-Limit-Reset'] = reset
    response.headers['X-Rate-Limit-Remaining'] = remaining
  end

  def get_limit
    limit = params[:limit].blank? ? Constants::DEFAULT_LIMIT : params[:limit].to_i
    limit = Constants::MAX_LIMIT if limit > Constants::MAX_LIMIT
    limit
  end

  def get_offset
    params[:offset].blank? ? Constants::DEFAULT_OFFSET : params[:offset].to_i
  end

  def get_sort
    sort = params[:sort]
    return nil if sort.blank?
    order = {}
    sort.split(',').each do |s|
      value = s.first == '-' ? :desc : :asc
      key = s.first == '-' ? s.slice(1, s.length) : s
      order[key] = value
    end
    return order
  end

  def get_radius
    params[:radius].blank? ? Constants::DEFAULT_RADIUS : params[:radius].to_i
  end

  def get_location
    location = params[:location]
    return nil if location.blank?
    {
      lat: location.split(',')[0],
      lng: location.split(',')[1]
    }
  end

  def is_enable_sort_key?(enable_keys)
    sort = get_sort
    return false unless sort.present?
    sort.keys.each do |key|
      unless enable_keys.include?(key)
        return false
      end
    end
    return true
  end

  def validate_page_params
    limit = params[:limit].to_i
    offset = params[:offset].to_i
    if limit < 0
      return render_400(ErrorCode::INVALID_PARAM, "limit には正の整数を指定してください。")
    end
    if limit > Constants::MAX_LIMIT
      return render_400(ErrorCode::INVALID_PARAM, "limit の指定数が最大値(#{Constants::MAX_LIMIT}件)を超えています。")
    end
    if offset < 0
      return render_400(ErrorCode::INVALID_PARAM, "offset には正の整数を指定してください。")
    end
  end

  def validate_distance_params
    location = params[:location]
    radius = params[:radius].to_i
    if location.present? && location.split(',').length != 2
      return render_400(ErrorCode::INVALID_PARAM, "location はカンマ区切りで緯度,経度の順で指定してください。")
    end
    if radius < 0
      return render_400(ErrorCode::INVALID_PARAM, "radius には正の整数を指定してください。")
    end
    if radius > Constants::MAX_RADIUS
      return render_400(ErrorCode::INVALID_PARAM, "radius の指定数が最大値(#{Constants::MAX_RADIUS})を超えています。")
    end
  end
end
