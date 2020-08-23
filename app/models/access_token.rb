class AccessToken < ApplicationRecord

  def update_count
    count = is_between_period?(self.requested_at) ? self.count_per_hour + 1 : 0
    self.update!(count_per_hour: count, requested_at: Time.now)
  end

  def get_rate_limit
    now = Time.now
    limit = self.limit_per_hour # 期間内(1時間)リクエストできる最大回数
    reset = now.beginning_of_hour.since(1.hour).to_i - now.to_i  # 次の期間(hh:00:00)までの秒数
    remaining = is_between_period?(self.requested_at) ? self.limit_per_hour - self.count_per_hour : self.limit_per_hour # 次の期間までにリクエストできる回数
    return limit, reset, remaining
  end

  def is_exceed_request?
    is_between_period?(self.requested_at) && self.count_per_hour >= self.limit_per_hour
  end

  private

  def is_between_period?(time)
    now = Time.now
    hour_range = now.beginning_of_hour.to_i..now.beginning_of_hour.since(1.hour).to_i
    hour_range.include?(time.to_i)
  end
end