class PhotosController < ApplicationController
  before_action :render_layout_if_format_html

  def index
    render json: Photo.all
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.request_id = params[:id]
    if current_user
      @photo.user_id = current_user.id
    end
    render json: @photo.save
  end

  def show
    render json: set_photo
  end

  def update
    render json: @photo.update(photo_params)
  end

  def destroy
    render json: @photo.destroy
  end

  private

  def set_photo
    @photo = Photo.find_by_id(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:description, :imageurl)
  end
end
