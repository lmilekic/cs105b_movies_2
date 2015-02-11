require_relative 'user.rb'
require_relative 'movie.rb'
require_relative 'movie_test.rb'
class MovieData
	@movies_hash
	@user_hash
	#creates new MovieData object
	def initialize(dataLocation, testLocation = nil)
		@movies_hash = {}
		@user_hash = {}
		if testLocation.nil? #we're not testing anything
			load_data(dataLocation + '/u.data')
		else #we're testing stuff
			load_data(dataLocation + '/' + testLocation.to_s + '.base')
			@testLocation = dataLocation + '/' + testLocation.to_s + '.test'
		end
	end
	#loads all the data from location passed to it
	def load_data(dataLocation)
		f = File.open(dataLocation, "r")
		f.each_line do |line|
			lineData = line.split("\t")
			lineData.map! { |e| e.to_i }
			add_to_user_hash(lineData[0], lineData[1], lineData[2])
			add_to_movie_hash(lineData[1], lineData[2])
		end
	end
	#adds user to hash with it's key being the user id
	def add_to_user_hash(user_id, movie_id, rating)
		if @user_hash[user_id].nil? #user doesn't exist yet
			@user_hash[user_id] = User.new(user_id)
		end
		@user_hash[user_id].add_rating(movie_id, rating)
	end
	#add a movie to the movie_hash with it's key being the movie id
	def add_to_movie_hash(movie_id, rating)
		if @movies_hash[movie_id].nil? #movie doesn't exist yet
			@movies_hash[movie_id] = Movie.new(movie_id)
		end
		@movies_hash[movie_id].add_rating(rating)
	end
	#sums the total of the movie's ratings
	def popularity(movie_id)
		movie = @movies_hash[movie_id]
		movie.total_ratings
	end
	#just sort the movies by popularity
	def popularity_list
		@movies_hash.keys.sort { |a, b| popularity(b) <=> popularity(a) }
	end
	#get the difference between the average rating of two users
	def similarity(user1, user2)
		5 - (@user_hash[user1].average_rating_given - @user_hash[user2].average_rating_given).abs
	end
	#sort users based on similarity
	def most_similar(user)
		similar_list = @user_hash.keys.sort { |a, b| similarity(b,user) <=> similarity(a,user) }
		similar_list.delete(user) #delete user from it's similarity list
		similar_list
	end
	#predict that the user will give their average rating
	def predict(user, movie)
		@user_hash[user].average_rating_given
	end
	#read in all the test data and run predictions on them
	def run_test(num_of_ratings = nil)
		test_data = read_test_data(num_of_ratings)
		predictions = run_predictions(test_data)
		MovieTest.new(predictions)
	end
	#read in all the test data
	def read_test_data(num_of_ratings)
		f = File.open(@testLocation, "r")
		counter = 0
		data_array = []
		f.each_line do |line|
			counter+= 1
			data_array << line.chomp.split[0..2]
			break if counter == num_of_ratings
		end
		data_array.each do |arr|
			arr.map!{|x| x.to_i}
		end
		data_array
	end
	#run predict on all the test_data
	def run_predictions(test_data)
		all_predictions = []
		test_data.each do |arr|
			all_predictions << (arr << predict(arr[0], arr[1]))
		end
		all_predictions
	end
	#returns the rating the user gave the movie
	def rating(user, movie)
		@user_hash[user].ratings_tuple.each do |rating|
			return rating.last if rating.first == movie
		end
		nil
	end
	#returns the movies seen by a user
	def movies(user)
		@user_hash[user].movies_rated_ids
	end
	#my movies-1 was specifically made to not do this. A movie shouldn't need to know who has seen it, and as such this function is extremely inefficient
	def viewers(movie)
		users = []
		@user_hash.keys.each do |user|
			users << user if rating(user, movie) != nil
		end
		users
	end

end
puts Time.now
m = MovieData.new('ml-100k', :ua)
t = m.run_test()
t.mean
t.stddev
t.rms
t.to_a
puts Time.now