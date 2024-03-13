# frozen_string_literal: true

# app/helpers/movies_helper.rb
module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ? 'odd' : 'even'
  end
end
