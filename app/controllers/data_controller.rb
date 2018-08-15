require 'csv'

class DataController < ApplicationController

	def browse
		@collections = Collection.all
		@count = @collections.length
	end

	def upload_data
		
	end

	def delete_data
		@collection = Collection.find(params[:id])
		@tweets = Tweet.where(id: @collection.id)

		@collection.destroy

		@tweets.each do |t|
			t.destroy
		end

		redirect_to "/collections"
	end

	def edit_data
		@collection = Collection.find(params[:id])
		
	end

	def update_data
		@collection = Collection.find(params[:id])

		@collection.collection_name = params[:collection_name]

		@collection.save

		redirect_to "/collections"
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
