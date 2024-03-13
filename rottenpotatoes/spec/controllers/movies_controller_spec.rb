# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  before do
    Movie.destroy_all

    Movie.create(title: 'Big Hero 6',
                 rating: 'PG',
                 release_date: '2014-11-07',
                 director: 'Don Hall, Chris Williams')

    # TODO(student): add more movies to use for testing
    Movie.create(title: 'The Grand Budapest Hotel',
                 rating: 'R',
                 director: 'Wes Anderson',
                 release_date: '2014-03-28')

    Movie.create(title: 'Moonrise Kingdom',
                 rating: 'PG-13',
                 director: 'Wes Anderson',
                 release_date: '2012-05-25')

    Movie.create(title: 'No Country for Old Men',
                 rating: 'R',
                 director: 'Joel and Ethan Coen',
                 release_date: '1982-11-21')

    Movie.create(title: 'The Lighthouse',
                 rating: 'R',
                 director: '',
                 release_date: '2019-10-18')
  end

  describe 'when trying to find movies by the same director' do
    it 'returns a valid collection when a valid director is present' do
      # TODO(student): implement this test
      m1 = Movie.find_by title: 'The Grand Budapest Hotel'
      m3 = Movie.find_by title: 'Moonrise Kingdom'
      get :same_director, params: { id: m1.id }
      expect(assigns(:movies)).to include(m3)
    end

    it 'redirects to index with a warning when no director is present' do
      # TODO(student): implement this test
      m1 = Movie.find_by(title: 'The Lighthouse')
      get :same_director, params: { id: m1.id }
      expect(response).to redirect_to(movies_path)
    end
  end

  describe 'creates' do
    it 'movies with valid parameters' do
      get :create, params: { movie: { title: 'Toucan Play This Game', director: 'Armando Fox',
                                      rating: 'G', release_date: '2017-07-20' } }
      expect(flash[:notice]).to match(/Toucan Play This Game was successfully created./)
      Movie.find_by(title: 'Toucan Play This Game').destroy
    end

    it 'redirects to home page' do
      get :create, params: { movie: { title: 'Toucan Play This Game', director: 'Armando Fox',
                                      rating: 'G', release_date: '2017-07-20' } }
      expect(response).to redirect_to movies_path
    end
  end

  describe 'updates' do
    it 'redirects to the movie details page and flashes a notice' do
      movie = Movie.create(title: 'Outfoxed!', director: 'Nick Mecklenburg', rating: 'PG-13',
                           release_date: '2023-12-17')
      get :update, params: { id: movie.id, movie: { description: 'Critics rave about this epic new thriller.' } }
      expect(flash[:notice]).to match(/Outfoxed! was successfully updated./)
      movie.destroy
    end

    it 'flashes a notice' do
      movie = Movie.create(title: 'Outfoxed!', director: 'Nick Mecklenburg', rating: 'PG-13',
                           release_date: '2023-12-17')
      get :update, params: { id: movie.id, movie: { description: 'Critics rave about this epic new thriller.' } }
      expect(flash[:notice]).to match('Outfoxed! was successfully updated.')
      movie.destroy
    end

    it 'actually does the update' do
      movie = Movie.create(title: 'Outfoxed!', director: 'Nick Mecklenburg',
                           rating: 'PG-13', release_date: '2023-12-17')
      get :update, params: { id: movie.id, movie: { director: 'Not Nick!' } }

      expect(assigns(:movie).director).to eq('Not Nick!')
      movie.destroy
    end
  end

  describe 'destroys' do
    it 'deletes the movie from the database' do
      m1 = Movie.find_by title: 'The Grand Budapest Hotel'

      get :destroy, params: { id: m1.id }

      movies = Movie.all
      expect(movies).not_to include(m1)
    end

    it 'redirects to the home page after deletion' do
      m1 = Movie.find_by title: 'The Grand Budapest Hotel'

      get :destroy, params: { id: m1.id }

      expect(response).to redirect_to movies_path
    end

    it 'flashes a warning after deletion' do
      m1 = Movie.find_by title: 'The Grand Budapest Hotel'

      get :destroy, params: { id: m1.id }

      expect(flash[:notice]).to match(/Movie '#{m1.title}' deleted./)
    end
  end
end
