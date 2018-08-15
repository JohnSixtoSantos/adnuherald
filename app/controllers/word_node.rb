require_relative "Pair"

class WordNode
	@word = ""
	@left = []
	@right = []
	@distance = 0
	@weight = 0
	@count = 0

	def initialize(word)
		@word = word
		@left = []
		@right = []
		@distance = 0
		@count = 1
	end

	def unique_insert_right(wn)
		dupl = false

		@right.each do |r|
			if r.word == wn.word then
				dupl = true
				r.count += 1
				break
			end
		end

		if dupl == false then
			@right.append(wn)
		end
	end

	def unique_insert_left(wn)
		dupl = false

		@left.each do |r|
			if r.word == wn.word then
				dupl = true
				r.count += 1
				break
			end
		end

		if dupl == false then
			@left.append(wn)
		end
	end

	def count
		return @count
	end

	def count=(s)
		@count = s
	end

	def weight
		return @weight
	end

	def weight=(s)
		@weight = s
	end

	def distance
		return @distance
	end

	def distance=(s)
		@distance = s
	end

	def word
		return @word
	end

	def word=(s)
		@word = s
	end

	def left
		return @left
	end

	def left=(s)
		@left = s
	end	

	def right
		return @right
	end

	def right=(s)
		@right = s
	end
end