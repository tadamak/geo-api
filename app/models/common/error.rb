class Common::Error
  include Swagger::ErrorSchema

  def initialize(error_code, message)
    @code = error_code[:code]
    @type = error_code[:type]
    @message = message
  end
end
