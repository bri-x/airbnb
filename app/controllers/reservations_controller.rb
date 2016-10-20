class ReservationsController < ApplicationController
  def show
  end

  def create
  	@reservation = current_user.reservations.new(reservation_params)
  	if @reservation.save
      redirect_to @reservation
    else
      render "listings/#{@listing.id}"
    end
  end

  private
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    return params.require(:reservation).permit(:in, :out, :no_guest)
  end
end
