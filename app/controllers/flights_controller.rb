require 'will_paginate/array'

class FlightsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    if params[:password] == ENV['POST_PASSWORD']
      respond_to do |format|
        flights = Flight.where("shortcut = ? AND cheapest_price > ? AND epic = ?", true, 0, true).order("price ASC").paginate(:page => 1, :per_page => 10)
        
        destinations = Flight.all.map{ |f| f.arrival_airport_id }.uniq

        format.json { render :json => { :flights => flights, :destinations => destinations } }
      end
    else
      format.json { render :json => { "message" => "Whatcha tryin' to pull?" } }
    end
  end

  # def filter
  #   params[:sort] == "Price" ? sort = "price ASC" : sort = "departure_time ASC"

  #   if params[:segment] == "Going"
  #     if params[:from] == "Any"
  #       from_where = "departure_airport_id > ?"
  #       from = 0
  #     else
  #       from_where = "departure_airport_id = ?"
  #       from = Airport.find_by_name(params[:from]).id
  #     end

  #     if params[:to] == "Any"
  #       to_where = "arrival_airport_id > ?"
  #       to = 0
  #     else
  #       to_where = "arrival_airport_id = ?"
  #       to = Airport.find_by_name(params[:to]).id
  #     end
  #   else
  #     @returning = true

  #     if params[:to] == "Any"
  #       to_where = "departure_airport_id > ?"
  #       to = 0
  #     else
  #       to_where = "departure_airport_id = ?"
  #       to = Airport.find_by_name(params[:to]).id
  #     end

  #     if params[:from] == "Any"
  #       from_where = "arrival_airport_id > ?"
  #       from = 0
  #     else
  #       from_where = "arrival_airport_id = ?"
  #       from = Airport.find_by_name(params[:from]).id
  #     end
  #   end

  #   if params[:dates] == ""
  #     start_date = Time.now - 1.year
  #     end_date = Time.now + 1.year
  #   else
  #     dates = params[:dates].split(" - ") 
  #     start_date = DateTime.strptime(dates[0], "%B %d, %Y")
  #     end_date = DateTime.strptime(dates[1], "%B %d, %Y") + 1.day
  #   end

  #   if params[:type] == "Epic"
  #     @flights = Flight.where("shortcut = ? AND cheapest_price > ? AND #{from_where} AND #{to_where} AND departure_time >= ? AND arrival_time <= ? AND epic = ?", true, 0, from, to, start_date, end_date, true).order(sort).paginate(:page => params[:page], :per_page => 10)
  #   else
  #     @flights = Flight.where("shortcut = ? AND cheapest_price > ? AND #{from_where} AND #{to_where} AND departure_time >= ? AND arrival_time <= ?", true, 0, from, to, start_date, end_date).order(sort).paginate(:page => params[:page], :per_page => 10)
  #   end

  #   @user = User.new

  #   @empty_search = false
  #   @empty_search = true if @flights.empty? && !params[:scroll]
    
  #   respond_to do |format|
  #     if @flights.any?
  #       format.json { render :json => { :flights => render_to_string('_flights.html.erb') } }
  #     elsif @empty_search
  #       format.json { render :json => { :flights => render_to_string('_flights.html.erb'), :noMoreFlights => true } }
  #     else
  #       format.json { render :json => { :flights => "<div class='no-more-flights label label-info'>No more flights to show</div>", :noMoreFlights => true } }
  #     end
  #   end
  # end

  def create
    respond_to do |format|
      if params[:password] == ENV['POST_PASSWORD']
        Flight.all.each { |flight| flight.update_attributes(:new => false) }
        Flight.where(:pure_date => params[:date]).destroy_all

        flights = params[:flights]

        flights.each do |k, flight|
          Flight.create(
            :departure_airport_id => flight["departure_airport_id"].to_i,
            :arrival_airport_id => flight["arrival_airport_id"].to_i,
            :departure_time => to_date(flight["departure_time"]),
            :arrival_time => to_date(flight["arrival_time"]),
            :airline => flight["airline"],
            :flight_no => flight["flight_no"],
            :price => flight["price"].to_i,
            :number_of_stops => flight["number_of_stops"].to_i,
            :is_first_flight => to_bool(flight["is_first_flight"]),
            :second_flight_destination => flight["second_flight_destination"].to_i,
            :second_flight_no => flight["second_flight_no"].to_i,
            :original_price => flight["original_price"].to_i,
            :origin_code => flight["origin_code"],
            :shortcut => to_bool(flight["shortcut"]),
            :pure_date => flight["pure_date"],
            :cheapest_price => flight["cheapest_price"].to_i,
            :epic => to_bool(flight["epic"]),
            :month => flight["month"],
            :new => to_bool(flight["new"]),
            :created_at => to_date(flight["created_at"]),
            :updated_at => to_date(flight["updated_at"])
          )
        end

        Flight.where(:new => false).destroy_all

        format.json { render :json => { "message" => "It's all good!" } }
      else
        format.json { render :json => { "message" => "Whatcha tryin' to pull?" } }
      end
    end
  end

  private

  def to_bool(str)
    str == "true"
  end

  def to_date(str)
    DateTime.strptime(str, "%Y-%m-%d %H:%M:%S %z")
  end
end