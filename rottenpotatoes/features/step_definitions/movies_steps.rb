
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1) < page.body.index(e2))
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(', ').each do |rating|
    step %{I #{uncheck.nil? ? '' : 'un'}check "ratings_#{rating}"}
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    step %{I should see "#{movie.title}"}
  end
end





When('I go to the edit page for {string}') do |title|
  movie = Movie.find_by(title: title)
  visit edit_movie_path(movie)
end
When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end
When('I press {string}') do |button_name|
  click_button(button_name)
end
Then('the director of {string} should be {string}') do |title, director|
  movie = Movie.find_by(title: title)
  expect(movie.director).to eq(director)
end
Given('I am on the details page for {string}') do |title|
  movie = Movie.find_by(title: title)
  visit movie_path(movie)
end
When('I follow {string}') do |link_text|
  click_link(link_text)
end
Then('I should be on the Similar Movies page for {string}') do |title|
  movie = Movie.find_by(title: title)
  expect(page).to have_current_path(same_director_movies_path(movie.director))
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should not see {string}') do |string|
  expect(page).to have_no_content(string)
end

Then('I should be on the home page') do
  expect(page).to have_current_path(root_path)
end

