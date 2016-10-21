class BookingMailer < ApplicationMailer
	def booking_email(booking)
		@booking = booking
		@customer = booking.booker
		@listing = booking.bookable
		@host = @listing.user
		@url = "localhost:3000" + user_path(@host)
		mail(to: @host.email, subject: 'You have new booking')
	end
end
