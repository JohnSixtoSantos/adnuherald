class GeoController < ApplicationController
	def select_data
		@tweets = Tweet.where(job_id: 1).limit(1000)

		@marks = []
		@heat = []

		@tweets.each do |t|
			@b = {}
			@b[:latlng] = [t.tweet_lat, t.tweet_lon]
			@b[:popup] = t.tweet_text
			@b[:icon] = {:icon_url => "https://cdn.jsdelivr.net/gh/pointhi/leaflet-color-markers@master/img/marker-icon-2x-green.png", :icon_size => [25, 41]}
			@marks.append(@b)

			#@heat.append([t.tweet_lat, t.tweet_lon])
		end
	end
end
