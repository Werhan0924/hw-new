# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  before(:all) do
    if described_class.where(title: 'Big Hero 6').empty?
      described_class.create(title: 'Big Hero 6',
                             rating: 'PG', release_date: '2014-11-07')
    end

    # TODO(student): add more movies to use for testing
    if described_class.where(title: 'The Grand Budapest Hotel').empty?
      described_class.create(title: 'The Grand Budapest Hotel',
                             rating: 'R',
                             director: 'Wes Anderson',
                             release_date: '2014-03-28')
    end

    if described_class.where(title: 'Moonrise Kingdom').empty?
      described_class.create(title: 'Moonrise Kingdom',
                             rating: 'PG-13',
                             director: 'Wes Anderson',
                             release_date: '2012-05-25')
    end

    if described_class.where(title: 'No Country for Old Men').empty?
      described_class.create(title: 'No Country for Old Men',
                             rating: 'R',
                             director: 'Joel and Ethan Coen',
                             release_date: '1982-11-21')
    end

    if described_class.where(title: 'The Lighthouse').empty?
      described_class.create(title: 'The Lighthouse',
                             rating: 'R',
                             director: '',
                             release_date: '2019-10-18')
    end
  end

  describe 'others_by_same_director method' do
    it 'returns all other movies by the same director' do
      # TODO(student): implement this test
      m1 = described_class.find_by title: 'The Grand Budapest Hotel'
      described_class.find_by title: 'No Country for Old Men'
      m3 = described_class.find_by title: 'Moonrise Kingdom'

      movies = described_class.with_same_director(m1.id)

      expect(movies).to include(m3)
    end

    it 'does not return movies by other directors' do
      # TODO(student): implement this test
      m1 = described_class.find_by title: 'The Grand Budapest Hotel'
      m2 = described_class.find_by title: 'No Country for Old Men'
      described_class.find_by title: 'Moonrise Kingdom'

      movies = described_class.with_same_director(m1.id)

      expect(movies).not_to include(m2)
    end
  end
end
