class SessionsController < ApplicationController
  before_action :render_layout_if_format_html

  def create
    @user = User.authenticate(params[:user][:email], params[:user][:password])
    
    if @user 
      session[:user_id] = @user.id
      render json: @user
    else
      flash.now[:notice] = "Invalid email or password"
      @user = User.new(email: params[:user][:email])
      render json: @user
    end
  end

  def destroy
    session[:user_id] = nil
    session["access_token"] = nil
    redirect_to root_path
  end

  private

end
