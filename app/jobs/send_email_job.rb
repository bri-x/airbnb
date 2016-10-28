class SendEmailJob < ActiveJob::Base
  queue_as :default

  def perform(reservation)
    BookingMailer::booking_email(reservation).deliver_now
  end
end
