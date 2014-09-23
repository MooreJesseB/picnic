class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def is_authenticated?
    redirect_to login_path unless current_user
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
    gon.currentUser = @current_user
  end

  def render_layout_if_format_html
    if request.format.symbol == :html
      render "layouts/application"
    end
  end

  def getGoogleKey
    gon.googleKey = ENV["GOOGLE_MAPS_KEY"]
    # render json: ENV["GOOGLE_MAPS_KEY"]
  end
  
end
