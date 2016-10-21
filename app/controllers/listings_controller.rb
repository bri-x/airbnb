class ListingsController < ApplicationController

  before_action :set_listing, only: [:show, :edit, :update, :destroy, :book]

  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.all
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
  end

  # GET /listings/new
  def new
    @listing = current_user.listings.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = current_user.listings.new(listing_params)
    @listing.amenity_list = params[:listing][:amenity]
    @listing.rule_list = params[:listing][:rule]
      if @listing.save
        redirect_to @listing, notice: 'Listing was successfully created.'
      else
        render :new
      end
  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    respond_to do |format|
      @listing.amenity_list = params[:listing][:amenity]
      @listing.rule_list = params[:listing][:rule]
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def book
    begin
      @booking = @listing.be_booked! current_user, booking_params
    rescue => detail
      redirect_to @listing, notice: detail.message
    else
      # BookingMailer.booking_email(@booking).deliver_later
      SendEmailJob.perform_later(@booking)
      redirect_to current_user
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      return params.require(:listing).permit(:name, :description, :property_type, :room_type, :capacity, :price, :min_stay, :address, :city_id, {photos:[]})
    end

    def booking_params
      hash = params.require(:booking).permit(:time_start, :time_end, :amount)
      hash[:time_start] = Date.parse(hash[:time_start]) + 1.hour
      hash[:time_end] = Date.parse(hash[:time_end])
      hash[:amount] = hash[:amount].to_i
      return hash
    end
end
