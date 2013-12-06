class FlightsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    respond_to do |format|
      if params[:password] == ENV['POST_PASSWORD']
        flights = params[:flights]
        flights.each do |flight|
          Flight.create(
            :departure_airport_id => flight["departure_airport_id"],
            :arrival_airport_id => flight["arrival_airport_id"],
            :departure_time => flight["departure_time"],
            :arrival_time => flight["arrival_time"],
            :airline => flight["airline"],
            :flight_no => flight["flight_no"],
            :price => flight["price"],
            :number_of_stops => flight["number_of_stops"],
            :is_first_flight => flight["is_first_flight"],
            :second_flight_destination => flight["second_flight_destination"],
            :second_flight_no => flight["second_flight_no"],
            :original_price => flight["original_price"],
            :origin_code => flight["origin_code"],
            :shortcut => flight["shortcut"],
            :pure_date => flight["pure_date"],
            :cheapest_price => flight["cheapest_price"],
            :epic => flight["epic"],
            :month => flight["month"],
            :new => flight["new"]
          )
        end
        format.json { render :json => { "message" => "It's all good!", "params" => params } }
      else
        format.json { render :json => { "message" => "Whatcha tryin' to pull?" } }
      end
    end
  end
end