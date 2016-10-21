class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show]
  
  def show
  end

  def create
    @reservation = current_user.reservations.new(reservation_params)
    @reservation.listing_id = params[:listing_id]
    if @reservation.save
      # SendEmailJob.perform_later(@reservation)
      @client_token = Braintree::ClientToken.generate
      @payment = Payment.new
      render 'payments/new'
    else
      render "listings/#{@listing.id}"
    end
  end

  private
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    hash = params.require(:reservation).permit(:time_start, :time_end, :amount)
    hash[:time_start] = Date.parse(hash[:time_start])
    hash[:time_end] = Date.parse(hash[:time_end])
    hash[:amount] = hash[:amount].to_i
    return hash
  end
end
