# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
 # fail "Unimplemented"
    @movies = Movie.all
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body).to match /#{e1}.*#{e2}/m
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/\W\s/).each do |rating|
    if uncheck
        step %Q{I uncheck "ratings[#{rating}]"}
    else
       step %Q{I check "ratings[#{rating}]"}
    end
  end
end


When(/^all ratings are selected$/) do
  	ratings = Movie.all_ratings
  	ratings.each do |rating|
    	step %Q{I check "ratings[#{rating}]"}
  	end
end

Then /I should see all the movies/ do
    rows = Movie.all.count
    expect(page.all('table#movies tr').count).to eq rows+1
end


Then(/^I should see movies with ratings: (.*?)$/) do |string|
	ok_list = string.split(/\W\s/)
	ok_movies = Movie.where(rating: ok_list)
	within("table#movies tbody") do
		expect(page).to have_content("#{ok_movies.first.title}")
		expect(page).to have_content("#{ok_movies.fourth.title}")
		expect(page).to have_content("#{ok_movies.last.title}")
    end
end

Then(/^should not see movies whose ratings are: (.*?)$/) do |ratings|
  ban_list = ratings.split(/\W\s/)
  banned_movies = Movie.where(rating: ban_list)
  within("table#movies tbody") do
      ban_list.each do |rating|
          expect(page).to have_no_content(/^#{rating}$/)
    end
  end
end

#If we want to restrict the search results strictly to the table#movies use the following step definitions instead
# Then(/^I should see "(.*?)" before "(.*?)"$/) do |string1, string2|
#   regexp = /#{string1}.*#{string2}/m
#   within_table('movies') do
#     expect(assert_text(:all, regexp)).to eq true
#   end
# end

Then(/^I should see the movies with earlier release dates first$/) do
  movies = Movie.order('release_date')
  first, middle, last = movies.first.title, movies.fourth.title, movies.last.title
  expect(page.body).to match /#{first}.*#{middle}.*#{last}/m
end

Then(/^the director of "(.*?)" should be "(.*?)"$/) do |movie, director|
  pending # express the regexp above with the code you wish you had
end