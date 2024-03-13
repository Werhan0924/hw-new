# frozen_string_literal: true

# app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = if params[:release_year_filter].present?
                Movie.where("strftime('%Y', release_date) = ?", params[:release_year_filter])
              else
                Movie.all
              end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find(params[:id])
    @movie.director = params[:director] if params[:director].present?
    if @movie.update(movie_params)
      # Include the movie's title in the flash notice
      redirect_to @movie, notice: "#{@movie.title} was successfully updated."
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def same_director
    movie = Movie.find(params[:id])
    @director = movie.director
    @movies = Movie.with_same_director(movie.id)
    return unless @movies.nil?

    flash[:warning] = "'#{movie.title}' has no director info"
    redirect_to movies_path
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end
