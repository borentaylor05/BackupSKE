class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def respond(response)
  	respond_to do |format|
  		format.any(:json, :html) { render json: response }
  	end
  end

end
