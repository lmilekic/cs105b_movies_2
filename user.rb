class User
	attr_accessor :id, :movies_rated_ids, :average_rating_given, :total_ratings_sum
	def initialize(id)
		@id = id
		@movies_rated_ids = []
		@average_rating_given = 0
		@total_ratings_sum = 0
	end
	def add_rating(movie_id, rating_given)
		@movies_rated_ids << movie_id
		@total_ratings_sum += rating_given
		@average_rating_given =  @total_ratings_sum.to_f / @movies_rated_ids.length
		@average_rating_given
	end
end