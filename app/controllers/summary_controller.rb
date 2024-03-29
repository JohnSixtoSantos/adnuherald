require "summarizer"

class SummaryController < ApplicationController
	def select_collection
		@collections = Collection.all
	end

	def view_result_sets
		@results = SummarizationResult.where(collection_id: params[:cid]).order(created_at: :desc)
		@collection = Collection.find(params[:cid])
	end

	def run_summarization
		@collection_id = params[:collection_id]
		@topic_word = params[:tword]
		@bval = params[:bval]

		socket = TCPSocket.new('0.0.0.0', 8081)

		socket.puts("summary")
		socket.puts(@collection_id)
		socket.puts(@topic_word.downcase)
		socket.puts(@bval.to_f)

		socket.close

		redirect_to "/summary"
	end
end
