class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def is_authenticated?
    redirect_to login_path unless current_user
  end

  def current_user
    gon.current_user ||= User.find_by_id(session[:user_id])
  end

  def render_layout_if_format_html
    if request.format.symbol == :html
      render "layouts/application"
    end
  end
  
end
