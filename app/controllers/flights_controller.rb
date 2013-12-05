class FlightsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    respond_to do |format|
      if params[:password] == ENV['POST_PASSWORD']
        format.json { render :json => { "message" => "It's all good!", "params" => params } }
      else
        format.json { render :json => { "message" => "Whatcha tryin' to pull?" } }
      end
    end
  end
end