module ErrorCode
  INVALID_PARAM = {
    code: 1001,
    type: 'invalid_param'
  }
  REQUIRED_PARAM = {
    code: 1002,
    type: 'required_param'
  }
  RATE_LIMIT_EXCEEDED = {
    code: 1003,
    type: 'rate_limit_exceeded'
  }
  ROUTE_NOT_FOUND = {
    code: 1004,
    type: 'route_not_found'
  }
  INTERNAL_SERVER_ERROR = {
    code: 9001,
    type: 'internal_server_error'
  }
end
