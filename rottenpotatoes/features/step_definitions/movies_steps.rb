# frozen_string_literal: true

Given(/the following movies exist/) do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
  end
end

Then(/I should see "(.*)" before "(.*)"/) do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1) < page.body.index(e2))
end

When(/I (un)?check the following ratings: (.*)/) do |uncheck, rating_list|
  rating_list.split(', ').each do |rating|
    step %(I #{uncheck.nil? ? '' : 'un'}check "ratings_#{rating}")
  end
end

Then(/I should see all the movies/) do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.find_each do |movie|
    step %(I should see "#{movie.title}")
  end
end

When('I go to the edit page for {string}') do |title|
  movie = Movie.find_by(title:)
  visit edit_movie_path(movie)
end
When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end
When('I press {string}') do |button_name|
  click_button(button_name)
end
Then('the director of {string} should be {string}') do |title, director|
  movie = Movie.find_by(title:)
  expect(movie.director).to eq(director)
end
Given('I am on the details page for {string}') do |title|
  movie = Movie.find_by(title:)
  visit movie_path(movie)
end
When('I follow {string}') do |string|
  click_link(string)
end
Then('I should be on the Similar Movies page for {string}') do |title|
  movie = Movie.find_by(title:)
  expect(page).to have_current_path(same_director_movies_path(movie))
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should not see {string}') do |string|
  expect(page).to have_no_content(string)
end

Then('I should be on the home page') do
  expect(page).to have_current_path(movies_path)
end

Given('I am on the homepage') do
  visit root_path
end

When('I filter movies by release year {string}') do |year|
  fill_in 'release_year_filter', with: year
  click_button 'Apply Filter'
end
