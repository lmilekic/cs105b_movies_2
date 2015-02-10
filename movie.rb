class Movie
	attr_accessor :id, :ratings, :average_rating, :total_ratings
	def initialize(id)
		@id = id
		@ratings = []
		@average_rating = 0
		@total_ratings = 0
	end
	def add_rating(rating)
		@ratings << rating
		@total_ratings += rating
		@average_rating =   @total_ratings / @ratings.length
	end
end