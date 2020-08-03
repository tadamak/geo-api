class ApplicationController < ActionController::API

  def render_400(error_code, message)
    render status: :bad_request, json: {
      error: Common::Error.new(error_code, message)
    }
  end
end
