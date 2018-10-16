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
			t = data_clean(t.tweet_text)
			if t != "" then
				@tweets.append(t)
			end
		end

		@result = summarize(@tweets, @topic_word.downcase, @bval.to_f)
	end
end
