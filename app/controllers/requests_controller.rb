class RequestsController < ApplicationController
  before_action :render_layout_if_format_html

  def index
    render json: Request.all
  end

  def create
    render json: Request.create(request_params)
  end

  def show
    render json: @request
  end

  def update
    render json: @request.update(request_params)
  end

  def destroy
    render json: @request.destroy
  end

  private

  def set_request
    @request = Request.find_by_id(params[:id])
  end

  def request_params
    params.require(:request).permit(:latitude, :longitude, :title, :description)
  end

  def render_layout_if_format_html
    if request.format.symbol == :html
      render "layouts/application"
    end
  end
end
