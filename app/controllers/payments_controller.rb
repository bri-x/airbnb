class PaymentsController < ApplicationController
	before_action :require_login

  def create
  	amount = params[:payment][:total_price]
    nonce = params[:payment_method_nonce]
    @reservation = Reservation.find(params[:payment][:reservation_id])

    @payment = Payment.new
    
    unless nonce
      @client_token = Braintree::ClientToken.generate
      render action: :new and return 
    end

    # checks date in database
    if @reservation.add_to_validities 
      
      @result = Braintree::Transaction.sale(
        amount: amount,
        payment_method_nonce: nonce
      )
      
      # checks for successful payment
      if @result.success?
        @reservation.confirm

        Payment.create(reservation_id: params[:payment][:reservation_id], braintree_payment_id: @result.transaction.id, status: @result.transaction.status, fourdigit: @result.transaction.credit_card_details.last_4)

        redirect_to listing_reservation_path(listing_id: @reservation.listing_id, id: @reservation), notice: "Congratulations! Your transaction is successful!" and return
      else
        flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
        @reservation.remove_validities
        @client_token = Braintree::ClientToken.generate
        render :new and return
      end

    else
      flash[:alert] = "Listing is no longer available on those dates!"
      id = @reservation.listing_id
      @reservation.destroy
      redirect_to listing_path(id)
    end
    

  end
end
