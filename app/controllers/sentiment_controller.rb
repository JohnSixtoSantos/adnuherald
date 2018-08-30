require 'liblinear'
require 'CSV'

class SentimentController < ApplicationController
	def select_collection
		@collections = Collection.all
	end

	def process_upload
		puts params
		@collection = Collection.new

		@collection.collection_name = params[:collection_name]
		@collection.save

		@label_set = LabelSet.new
		@label_set.label_set_name = params[:label_set_name]
		@label_set.collection_id = @collection.id
		@label_set.save

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

				@attach_label = Label.new
				@attach_label.label = r[10]
				@attach_label.tweet_id = @tweet.id
				@attach_label.label_set_id = @label_set.id

				@tweet.save
			end
		end
	end

	def show_training_page
		#get tweets related to the collection selected
		@tweets = Tweet.where(job_id: params[:collection_id])

		#randomize the tweets
		@tweets = @tweets.shuffle

		#select the top n percent of the randomized tweetset
		first_bound = (@tweets.length * params[:percent].to_f).floor
		@tweets = @tweets[0...first_bound]
	end

	def train_model
		if params[:commit] == "Save" then
			@label_set = LabelSet.new
			@label_set.collection_id = params[:collection_id]
			@label_set.label_set_name = params[:label_set_name] + " (" + DateTime.now.to_s + ")"
			@label_set.percent = params[:percent]
			@label_set.save

			params["tweets"].each do |tid|
				@tweets = Tweet.find(tid)				

				@nlabel = Label.new
				@nlabel.tweet_id = tid
				@nlabel.label = params["sentiment" + tid.to_s].to_i
				@nlabel.label_set_id = @label_set.id
				@nlabel.save
			end

			redirect_to "/sentiment"

		elsif params[:commit] == "Use Labeled Set" then
			@label_set_id = params[:label_set_id]

			@collection_id = LabelSet.find(@label_set_id).collection_id
			
			@testing_set = []
			@training_set = []
			@raw_tweets = Tweet.where(job_id: @collection_id)
			labels = []

			@raw_tweets.each do |t|
				@temp_label = Label.where(label_set_id: @label_set_id).where(tweet_id: t.id)
				if @temp_label[0].nil? then
					ntweet = Tweet.find(t.id)
					@testing_set.append(ntweet)
				else
					ntweet = Tweet.find(t.id)
					@training_set.append(ntweet)
					labels.append(@temp_label[0].label)
					p ntweet
					p @temp_label[0].label
				end
			end			

			@train_tweets = stringarr_to_vector(@training_set)
			@test_tweets = stringarr_to_vector(@testing_set)

			model = Liblinear.train(
		  	{ solver_type: Liblinear::L2R_LR  },   # parameter
		 	 labels,                       # labels (classes) of training data
		 	 @train_tweets,
		 	 1 # training data
			)

			i = 0
			matches = 0

			@pred = []

			@test_tweets.each do |data|
				@pred.append(Liblinear.predict(model, data))
			end

			@disp_tweets = @testing_set
		else
			@tweets = Tweet.where(job_id: params[:collection_id])
			
			first_bound = (@tweets.length * params[:percent].to_f).floor

			puts "Percent: " + params[:percent].to_s

			dict = Hash.new
			words = []
			labels = []

			f = true

			@tweets.each do |r|
				b = r.tweet_text.split(' ')

				labels.append(params["sentiment" + r.id.to_s].to_i)

				b.each do |bw|
					words.append(bw)
				end
			end

			uniques = words.uniq.sort
			ulen = uniques.length

			ctr = 0
			uniques.each do |u|
				dict[u] = ctr
				ctr += 1
			end

			dataset = []
			
			@tweets.each do |r|
				bow = Array.new(ulen, 0)

			    b = r.tweet_text.split(' ')
			    b.each do |bw|
				    bow[dict[bw]] = 1 
				end

				dataset.append(bow)
			end

			@train_tweets = dataset[0...first_bound]
			@test_tweets = dataset[first_bound...@tweets.length]

			puts first_bound

			@train_labels = labels[0...first_bound]
			#@test_labels = labels[first_bound...@tweets.length]

			puts @train_labels

			model = Liblinear.train(
		  	{ solver_type: Liblinear::L2R_LR },   # parameter
		 	 @train_labels,                       # labels (classes) of training data
		 	 @train_tweets, # training data
			)

			i = 0
			matches = 0

			@pred = []

			@test_tweets.each do |data|
				@pred.append(Liblinear.predict(model, data))

				#puts @test_labels[i]

				#if @pred[i] == @test_labels[i] then
				#	matches += 1	
				#end
				#i += 1		
			end

			#@accuracy = (matches.to_f / @test_tweets.length.to_f) * 100

			@disp_tweets = @tweets[first_bound...@tweets.length]
		end
	end
end


