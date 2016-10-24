class BookingMailer < ApplicationMailer
	def booking_email(reservation)
		@reservation = reservation
		@customer = reservation.user
		@listing = reservation.listing
		@host = @listing.user
		@url = "localhost:3000" + user_path(@host)
		mail(to: @host.email, subject: 'You have new booking')
	end
end
