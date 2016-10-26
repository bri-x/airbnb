class SearchController < ApplicationController
  def search
  	
  	# @filter_capacity = Listing.select(:capacity).group(:capacity).count
  	# @filter_room = Listing.select(:capacity).group(:room_type).count
  	# @filter_property = Listing.select(:capacity).group(:property_type).count	
    params[:date] ||= Hash.new
  	@results = Listing.filter(search_filters).paginate(:page => params[:page])
  	if @results.count < 5
  		@similar = Listing.filter(similar_filters)
  	end

    params[:location] = params[:location].tr('%', '').capitalize
  end


  private
  def search_filters
  	params.permit(:location, :capacity, :date => {}, :price => [], :room_type => [], :property_type => []).tap do |permitted|
			permitted[:location] = params[:location]
  		(permitted[:location].length).downto(0) { |i| permitted[:location] = permitted[:location].insert(i, "%")}
  		permitted[:price] = params_to_range(params[:price]) if params[:price].present?
  	end
  end

  def similar_filters
    search_filters.tap do |permitted|
			permitted[:price] = Range.new(permitted[:price].first.first.to_i/2, permitted[:price].last.last.to_i*1.25) if params[:price].present?
  		permitted[:capacity] = Range.new(params[:capacity].to_i-1, params[:capacity].to_i+2) if params[:capacity].present?
  	end
  end

  def params_to_range(price_ranges)
  	range = []
  	lhs = '0'
  	rhs = '0'

  	price_ranges.each do |price|
			if price.include?('-')
				price = price.split('-')
				if rhs == price[0]
					rhs = price[1]
				else
					range << Range.new(lhs, rhs) if rhs != '0'
					lhs = price[0]
					rhs = price[1]
				end
			else
				price = price.tr('><','')
				if rhs == price
					rhs = '5000'
				else
					if price == '100'
						rhs = '100'
					else
						range << Range.new(lhs, rhs) if rhs != '0'
						lhs = '2500'
						rhs = '5000'
					end
				end
			end
  	end
  	range << Range.new(lhs, rhs)
  	
  	return range
  end
end
