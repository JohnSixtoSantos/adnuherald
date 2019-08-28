require 'csv'
require 'whatlanguage'

class DataController < ApplicationController
	def export
		collection_id = params[:id]

		@tweets = Tweet.where(job_id: collection_id)

		send_data @tweets.to_csv, filename: "export.csv"
	end

	def create_job
		@keywords = params[:keywords]
		@n_collection = Collection.new
		@n_collection.collection_name = params[:job_name]
		@n_collection.save

		p @n_collection.id
		p @keywords

		socket = TCPSocket.new('0.0.0.0', 8081)

		socket.puts("start_collection")
		socket.puts(@n_collection.id)
		socket.puts(@keywords)

		socket.close

		redirect_to "/browse"
	end

	def stop_job
		p "Stopping Job"

		socket = TCPSocket.new('0.0.0.0', 8081)

		socket.puts("stop_collection")

		socket.close

		redirect_to "/browse"
	end

	def new_job
	end

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
		@job_id = params[:coll_id]

		@tweet_count = @tweets.length
		@sum_word_count = 0
		@length_dist = {}

		@tweets.each do |t|
			tweet = t

			t_length = tweet.tweet_text.split(" ").length

			@sum_word_count += t_length

			if @length_dist[t_length].nil? then 
				@length_dist[t_length] = 1
			else
				@length_dist[t_length] += 1
			end
		end

		if @tweet_count > 0 then
			@avg_word_count = @sum_word_count / @tweet_count
		else
			@avg_word_count = 0
		end

		@time_tweets = Tweet.where(job_id: params[:coll_id]).group_by_day(:tweet_time).count
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

		redirect_to "/collections"
	end
end
