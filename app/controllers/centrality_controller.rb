require_relative "Word"

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

		@words = []

		@user_hash.each do |k,v|
			m = Word.new
			m.text = k
			m.weight = v

			@words.append(m)
		end

		#Betweeness Centrality 
		graph = RGL::DirectedAdjacencyGraph.new

		@user_hash.each do |k, v|
			graph.add_vertices(k)
		end

		edge_weights = {}

		@tweets.each do |tweet|
			i = 0

			@user_hash.each do |k,v|
				if data_clean(tweet.tweet_text).include? k then
					arg_edge = [data_clean(tweet.tweet_user), k]
					if edge_weights[arg_edge] == 0 then
						edge_weights[arg_edge] += 1
					else
						edge_weights[arg_edge] = 0
					end
				end
			end
		end

		edge_weights.each { |(city1, city2), w| graph.add_edge(city1, city2) }
		graph.write_to_graphic_file('jpg')
	end
end
