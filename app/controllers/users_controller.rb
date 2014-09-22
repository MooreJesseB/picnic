class UsersController < ApplicationController
  before_action :render_layout_if_format_html

  def index
    redirect_to root_path
  end

  def create
    user_params = params.require(:user).permit(:name, :email, :email_confirmation, :password, :password_confirmation)
    @user = User.create(user_params)

    if @user.errors.count > 0
      @user.errors.each do |key, value|
        error_string = "#{key} #{value}"
        error_string = error_string.slice(0, 1).capitalize + error_string.slice(1..-1)
        flash.now[:notice] = error_string
      end
    end
    
    if flash.count > 0
      @user.destroy
      @user = User.new(user_params)
      render json: @user
    else
      puts "*"*60
      puts "Creating new User!!!"
      @user = User.authenticate(@user.email, user_params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "You've logged in!"
      # redirect_to @user
      render json: @user
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    @current_user = current_user
  end
end
