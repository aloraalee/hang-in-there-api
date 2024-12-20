class Api::V1::PostersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    posters = Poster.all

    posters = posters.where("price >= ?", params[:min_price]) if params[:min_price].present?
    posters = posters.where("price <= ?", params[:max_price]) if params[:max_price].present?

    posters = posters.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
    

    if params[:sort] == "asc"
    sorted_asc = posters.order(:created_at)
      render json: PosterSerializer.format_posters(sorted_asc)
    elsif params[:sort] == "desc"
      sorted_desc = posters.order(created_at: :desc)
      render json: PosterSerializer.format_posters(sorted_desc)
    else  
      render json: PosterSerializer.format_posters(posters)
    end
  end

  def show
    poster = Poster.find(params[:id])
    if poster
      render json: PosterSerializer.format_poster(poster)
    else
      render json: {error: "Poster not found" }, status: :not_found
    end
  end

  def create
    poster = Poster.create(poster_params)
    if poster
      render json: PosterSerializer.format_posters([poster]), status: :created
    else
      render json: {
        errors: [
          {
            status: "422",
            message: poster.errors.error_messages.join(", ")
          }
        ]
      }, status: :unprocessable_entity
    end
  end

  def update
    poster = Poster.find(params[:id])
    if poster
      if params[:poster][:name].blank?
        render json: {
          errors: [
            {
              status: "422",
              message: "Name cannot be blank."
            }
          ]
        }, status: :unprocessable_entity
      elsif poster.update(poster_params)
        render json: poster
      else
        render json: {
          errors: [
            {
              status: "422",
              message: poster.errors.error_messages.join(", ")
            }
          ]
        }, status: :unprocessable_entity
      end
    else
      render json: {
        errors: [
          {
            status: "404",
            message: "Record not found"
          }
        ]
      }, status: :not_found
    end
  end

  def destroy
    poster = Poster.find(params[:id])
    if poster
      poster.destroy
      render json: { message: "Poster deleted successfully" }, status: :ok
    else
      render json: { error: "Postere not found" }, status: :not_found
    end
  end

  private
    
  def poster_params                                                                                                                                                                                                                                                                                                                                                                              
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end

  def not_found_response
    render json: { errors: [{ status: '404', message: 'Poster not found'}] }, status: :not_found
  end

  def error_messages(errors)
    errors.map do |attribute, message|
      {
        status: '422',
        message: "#{attribute.to_s.titleize} #{message}",
        details: "The field '#{attribute}' is invalid: #{message}."
      }
    end
  end

end
