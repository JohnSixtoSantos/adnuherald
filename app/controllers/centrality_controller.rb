require_relative "Word"
require_relative "Node"
require_relative "Edge"
require "rgl/adjacency"
require "rgl/dot"

class CentralityController < ApplicationController
	def view_result_sets
		puts "AAAAAAA"
		@results = CentralityResultSet.where(collection_id: params[:cid]).order(created_at: :desc)
		
		@collection = Collection.find(params[:cid])
	end

	def view_results
		@user_hash = CentralityUserHash.where(centrality_result_set_id: params[:cid])
		@db_nodes = CentralityNode.where(centrality_result_set_id: params[:cid])
		@db_edges = CentralityEdge.where(centrality_result_set_id: params[:cid])

		@nodes = []
		@edges = []

		@db_nodes.each do |n|
			@nodes.append(
				{
					"id" => n.label,
					"label" => n.label,
					"size" => n.size,
					"x" => n.x_pos,
					"y" => n.y_pos
				}
			)
		end
	# 		n = Edge.new
	# 		n.id = "e" + i.to_s
	# 		n.source = s
	# 		n.target = d
	# 		n.size = 1
	# 		n.color = "#ccc"
		@db_edges.each do |n|
			@edges.append(
				{
					"source" => n.source,
					"target" => n.target,
					"size" => n.size,
					"id" => n.edge_number,
					"color" => n.color
				}
			)
		end

	end

	def select_collection
		@collections = Collection.all
	end

	def calculate_centrality
		#INPUTS
		#Tweet Set

		@collection_id = params[:collection_id]

		socket = TCPSocket.new('0.0.0.0', 8081)

		socket.puts("centrality")
		socket.puts(@collection_id)

		socket.close

		redirect_to "/centrality"

	# 	@tweets = Tweet.where(job_id: params[:collection_id])
	# 	@usernames = []
	# 	@nodes = []
	# 	@edges = []
		
	# 	@tweets.each do |tweet|
	# 		@usernames.append(tweet.tweet_user.downcase)
	# 	end

	# 	@usernames = @usernames.uniq
		
	# 	@user_hash = {}

	# 	@usernames.each do |u|
	# 		uclean = data_clean(u)
	# 		@user_hash[uclean] = 0
	# 		n = Node.new
	# 		n.id = uclean
	# 		n.label = uclean
	# 		n.size  = 0
	# 		n.x = rand(1000)
	# 		n.y = rand(1000)

	# 		@nodes.append(n)
	# 	end

	# 	@tweets.each do |tweet|
	# 		i = 0
			
	# 		(0...@usernames.length).each do |i|
	# 			clean_username = data_clean(@usernames[i])

	# 			if data_clean(tweet.tweet_text).include? clean_username then
	# 				@user_hash[clean_username] += 1
	# 			end
	# 		end
	# 	end

	# 	@user_hash = @user_hash.sort_by{|k,v| v}.reverse.to_h

	# 	@words = []

	# 	@user_hash.each do |k,v|
	# 		m = Word.new
	# 		m.text = k
	# 		m.weight = v

	# 		@words.append(m)
	# 	end

	# 	#Degree Centrality 
	# 	graph = RGL::DirectedAdjacencyGraph.new

	# 	@user_hash.each do |k, v|
	# 		graph.add_vertices(k)
	# 	end

	# 	edge_weights = {}
	# 	@in_degrees = {}

	# 	@tweets.each do |tweet|
	# 		i = 0

	# 		@user_hash.each do |k,v|
	# 			if data_clean(tweet.tweet_text).include? k then
	# 				arg_edge = [data_clean(tweet.tweet_user), k]
	# 				if edge_weights[arg_edge].nil? then
	# 					edge_weights[arg_edge] = 1
	# 				else
	# 					edge_weights[arg_edge] += 1
	# 				end

	# 				if @in_degrees[k].nil? then #ERROR NODE SIZE IS MENTION SIZE NOT DEGREE
	# 					@in_degrees[k] = 1
	# 				else
	# 					@in_degrees[k] += 1
	# 				end
	# 			end
	# 		end
	# 	end

	# 	edge_weights.each { |(city1, city2), w| graph.add_edge(city1, city2) }

	# 	i = 0
	# 	edge_weights.each do |(s, d), w|

	# 		n = Edge.new
	# 		n.id = "e" + i.to_s
	# 		n.source = s
	# 		n.target = d
	# 		n.size = 1
	# 		n.color = "#ccc"
	# 		@edges.append(n)

	# 		i += 1
	# 	end

	# 	@nodes.each do |n|
	# 		n.size = 1

	# 		@in_degrees.each do |k, v|
	# 			if k == n.label then
	# 				n.size = v
	# 				break
	# 			end
	# 		end
	# 	end
	end
end
