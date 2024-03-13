# frozen_string_literal: true

class Movie < ActiveRecord::Base
  def self.with_same_director(id)
    movie = Movie.find(id)
    return nil if movie.director.blank? || movie.director.nil?

    Movie.where(director: movie.director)
  end
end
