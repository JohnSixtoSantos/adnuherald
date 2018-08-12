require 'csv'

class DataController < ApplicationController
	def browse
	end

	def upload_data
		
	end

	def view_data
		@tweets = Tweet.where(job_id: params[:coll_id])
	end

	def collections
		@collections = Collection.all
	end

	def process_upload
		puts params
		@collection = Collection.new

		@collection.collection_name = params[:collection_name]

		@collection.save

		uploaded_io = params[:tweet_file]

		f = true

  		CSV.foreach(uploaded_io.path) do |r|
			if f then
				f = false
			else
				@tweet = Tweet.new
				@tweet.tweet_text = r[1]
				@tweet.tweet_lat = r[2]
				@tweet.tweet_lon = r[3]
				@tweet.tweet_user = r[4]
				@tweet.tweet_time = r[5]
				@tweet.job_id = @collection.id

				@tweet.save
			end
		end
	end
end
