class FlightsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    respond_to do |format|
      puts "*" * 100
      puts "I got yo stuff!"
      puts params
      format.json { render :json => { "message" => "It's all good!" } }
    end
  end
end