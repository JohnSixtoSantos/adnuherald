class GeoController < ApplicationController
	def select_data
		@tweets = Tweet.where(job_id: 5).limit(1000)

		@marks = []

		@tweets.each do |t|
			@b = {}
			@b[:latlng] = [t.tweet_lat, t.tweet_lon]
			@b[:popup] = t.tweet_text
			@marks.append(@b)
		end
	end
end
