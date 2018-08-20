require "summarizer"

class SummaryController < ApplicationController
	def select_collection
		@collections = Collection.all
	end

	def run_summarization
		@collection_id = params[:collection_id]
		@topic_word = params[:tword]
		@bval = params[:bval]

		@raw_tweets = Tweet.where(job_id: @collection_id)

		@tweets = []

		@raw_tweets.each do |t|
			@tweets.append(data_clean(t.tweet_text))
			#@tweets.append(t.tweet_text.downcase)
		end

		@result = summarize(@tweets, @topic_word.downcase, @bval.to_f)
	end
end
