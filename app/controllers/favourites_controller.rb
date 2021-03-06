class FavouritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallpaper
  before_action :set_favourite, only: [:update, :destroy]

  layout false

  # POST /wallpapers/1/favourites
  # POST /wallpapers/1/favourites.json
  def create
    @favourite = @wallpaper.favourites.find_or_initialize_by(user: current_user)

    if @favourite.save
      render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper, favourite: @favourite }
    else
      render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper, favourite: @favourite }, status: :unprocessable_entity
    end
  end

  # PATCH /wallpapers/1/favourites/1
  # PATCH /wallpapers/1/favourites/1.json
  def update
    if favourite_params[:collection_id].present?
      @collection = Collection.find(favourite_params[:collection_id])
      authorize! :crud, @collection
      @favourite.collection = @collection
    else
      @favourite.collection = nil
    end

    if @favourite.save
      render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper, favourite: @favourite }
    else
      render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper, favourite: @favourite }, status: :unprocessable_entity
    end
  end

  # DELETE /wallpapers/1/favourites/1
  # DELETE /wallpapers/1/favourites/1.json
  def destroy
    @favourite.destroy

    render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper, favourite: nil }
  end

  private
    def set_wallpaper
      @wallpaper = Wallpaper.find(params[:wallpaper_id])
      authorize! :read, @wallpaper
    end

    def set_favourite
      @favourite = @wallpaper.favourites.find(params[:id])
      authorize! :crud, @favourite
    end

    def favourite_params
      params.require(:favourite).permit(:collection_id)
    end
end