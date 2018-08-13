require 'lda-ruby'

class TopicController < ApplicationController
	def select_collection
		@collections = Collection.all
	end

	def run_lda
		nwords = params[:nwords].to_i
		ntopics = params[:ntopics].to_i
		@collection = Collection.find(params[:collection_id])
		@tweets = Tweet.where(job_id: @collection.id)


		corpus = Lda::Corpus.new

		@tweets.each do |r|
			corpus.add_document(Lda::TextDocument.new(corpus, data_clean(r.tweet_text.to_s)))
		end

		lda = Lda::Lda.new(corpus)
		lda.verbose = false
		lda.num_topics = ntopics

		lda.em("random")

		topics = lda.top_words(nwords)

		@topic_mat = []

		(0...ntopics).each do |i|
			temp = []

			topics[i].each do |word|
				temp.push(word)
			end

			@topic_mat.push(temp)
		end

		@topic_mat = unique_words(@topic_mat)
	end
end
