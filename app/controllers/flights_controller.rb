class FlightsController < ApplicationController
  skip_before_filter :verify_authenticity_token

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