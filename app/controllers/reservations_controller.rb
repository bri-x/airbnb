class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show]
  before_action :require_login, only: [:create]
  
  def show
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @reservation = @listing.reservations.new(reservation_params)
    @reservation.user_id = current_user.id
    @reservation.total_price = calculate_price
    if @reservation.is_valid?
      @reservation.save
      @client_token = Braintree::ClientToken.generate
      @payment = Payment.new
      render 'payments/new'
    else
      render "listings/show"
    end
  end

  private
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    hash = params.require(:reservation).permit(:date_start, :date_end, :amount)
    hash[:date_start] = Date.strptime(hash[:date_start], '%d-%m-%Y')
    hash[:date_end] = Date.strptime(hash[:date_end], '%d-%m-%Y')
    hash[:amount] = hash[:amount].to_i
    return hash
  end

  def calculate_price
    price = @reservation.listing.price
    days = @reservation.calculate_days
    return price * days
  end
end
