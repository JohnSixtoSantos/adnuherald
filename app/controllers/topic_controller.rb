require 'lda-ruby'

class TopicController < ApplicationController
	def view_result_sets
		@results = TopicAnalysisResult.where(collection_id: params[:cid]).order(created_at: :desc)
		@collection = Collection.find(params[:cid])
	end

	def view_results
		@topics = Topic.where(topic_result_id: params[:cid]).order(:topic_number)
	end

	def select_collection
		@collections = Collection.all
	end

	def run_lda
		nwords = params[:nwords].to_i
		ntopics = params[:ntopics].to_i
		desc = params[:desc]
		@collection = Collection.find(params[:collection_id])
		@tweets = Tweet.where(job_id: @collection.id)

		#CODE FOR ASYNCHRONOUS PROCESSING

		socket = TCPSocket.new('0.0.0.0', 8081)

		socket.puts("topic")
		socket.puts(@collection.id)
		socket.puts(ntopics)
		socket.puts(nwords)
		socket.puts(desc)

		socket.close

		redirect_to "/topic"

		#corpus = Lda::Corpus.new

		#@tweets.each do |r|
		#	corpus.add_document(Lda::TextDocument.new(corpus, data_clean(r.tweet_text.to_s)))
		#end

		#lda = Lda::Lda.new(corpus)
		#lda.verbose = false
		#lda.num_topics = ntopics

		#lda.em("random")

		#topics = lda.top_words(nwords)

		#@topic_mat = []

		#(0...ntopics).each do |i|
		#	temp = []

		#	topics[i].each do |word|
		#		temp.push(word)
		#	end

		#	@topic_mat.push(temp)
		#end

		#@n_topic_results = TopicAnalysisResult.new
		#@n_topic_results.description = "DESCRIPTION HERE"
		#@n_topic_results.collection_id = params[:collection_id]
		#@n_topic_results.save

		#i = 0
		#@topic_mat.each do |row|
		#	j = 0
		#	row.each do |item|
		#		@n_tword = TopicWord.new
		#		@n_tword.topic_number = i 
		#		@n_tword.word = item
		#		@n_tword.order_number = j
		#		@n_tword.topic_analysis_result_id = @n_topic_results.id
		#		@n_tword.save
		#		j += 1
		#	end
		#	i += 1
		#end

		#@topic_mat = unique_words(@topic_mat)
	end
end
