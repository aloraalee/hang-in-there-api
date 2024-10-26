class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all

    posters = posters.where("price >= 99.99", params[:min_price]) if params[:min_price].present?
    posters = posters.where("price <= 99.99", params[:max_price]) if params[:max_price].present?

    posters = posters.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
    

    if params[:sort] == "asc"
    sorted_asc = posters.sort_by(&:created_at)
      render json: PosterSerializer.format_posters(sorted_asc)
    elsif params[:sort] == "desc"
      sorted_desc = posters.sort_by(&:created_at).reverse
      render json: PosterSerializer.format_posters(sorted_desc)
    else  
      render json: PosterSerializer.format_posters(posters)
    end
  end

  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.format_poster(poster)
  end

  def create
    poster = Poster.create(poster_params)
    render json: PosterSerializer.format_posters([poster])
  end

  def update
    render json: Poster.update(params[:id], poster_params)
  end

  def destroy
    render json: Poster.delete(params[:id])
  end

  private
    
  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end
