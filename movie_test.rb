class MovieTest
	@predictions
	@error_list
	#makes a new MovieTest object
	def initialize(predictions)
		@predictions = predictions
		@error_list = make_error_list
	end
	#creates a list of errors to stop computing the same thing over and over
	def make_error_list
		error_list = []
		@predictions.each do |arr|
			error_list <<(arr[2] - arr[3]).abs
		end
		error_list
	end
	#loops over the error list and returns the mean
	def mean
		sum = @error_list.inject{|sum, x| sum + x}
		sum / @predictions.size.to_f
	end
	#takes the square root of the variance
	def stddev
		Math.sqrt(variance)
	end
	#calculates the variance
	def variance
		variance_mean = self.mean
		subtract_mean_list = []
		@error_list.each do |num|
			subtract_mean_list << num - variance_mean
		end
		subtract_mean_list.map! { |e| e**2 }
		subtract_mean_list.inject{|sum, x| sum + x} / subtract_mean_list.size.to_f
	end
	#creates the root mean square error
	def rms
		sum = (@error_list.inject { |sum, x| sum + x } ** 2) / @error_list.size
		Math.sqrt(sum)
	end
	#returns predictions
	def to_a
		@predictions
	end

end