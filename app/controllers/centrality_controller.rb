class CentralityController < ApplicationController
	def select_collection
		@collections = Collection.all
	end

	def calculate_centrality
		@tweets = Tweet.where(job_id: params[:collection_id])
		@usernames = []
		
		@tweets.each do |tweet|
			@usernames.append(tweet.tweet_user.downcase)
		end

		@usernames = @usernames.uniq
		
		@user_hash = {}

		@usernames.each do |u|
			@user_hash[u] = 0
		end

		@tweets.each do |tweet|
			i = 0
			(0...@usernames.length).each do |i|
				if data_clean(tweet.tweet_text).include? @usernames[i] then
					@user_hash[@usernames[i]] += 1
				end
			end
		end

		@user_hash = @user_hash.sort_by{|k,v| v}.reverse.to_h
	end
end
