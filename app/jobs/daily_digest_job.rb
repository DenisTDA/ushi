class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    Postman::DailyDigest.new.send_digest
  end
end
