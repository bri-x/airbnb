# Preview all emails at http://localhost:3000/rails/mailers/reservation_mailer
class BookingMailerPreview < ActionMailer::Preview
	def booking_email
    BookingMailer.booking_email(Listing.last.reservations[0])
  end
end
