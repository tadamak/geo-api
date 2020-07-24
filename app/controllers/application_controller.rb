class ApplicationController < ActionController::API

  def render_400(error_code, message)
    locals = {
      error_code: error_code,
      message: message
    }
    render status: :bad_request, formats: :json, template: "v1/errors/index", locals: locals
  end
end
