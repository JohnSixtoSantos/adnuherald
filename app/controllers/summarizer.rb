require "csv"
require "pair"
require "word_node"

def tokenize(s)
	if s != nil && s.length > 0 
		return s.split(' ')
	else
		return ""
	end
end

def expand(node, alignment, offset, tweets, direction)
	if direction == 'r' then
		i = 0

		(0...tweets.length).each do |i|
			tok = tokenize(tweets[i])
			word = tok[alignment[i] + offset]

			if word != nil && (node.word == tok[alignment[i] + offset - 1]) then
				node.unique_insert_right(WordNode.new(word))
			end
		end

		node.right.each do |r|
			expand(r, alignment, offset + 1, tweets, 'r')
		end
	else
		i = 0

		(0...tweets.length).each do |i|
			tok = tokenize(tweets[i])
			word = tok[alignment[i] - offset]

			if word != nil && (node.word == tok[alignment[i] - offset + 1]) then
				node.unique_insert_left(WordNode.new(word))
			end
		end

		node.left.each do |r|
			expand(r, alignment, offset + 1, tweets, 'l')
		end
	end
end

def gen_distance_r(root)
	children = root.right

	children.each do |c|
		c.distance = root.distance + 1
		gen_distance_r(c)
	end
end

def gen_distance_l(root)
	children = root.left

	children.each do |c|
		c.distance = root.distance + 1
		gen_distance_l(c)
	end
end

def gen_weights_r(root, b)
	root.weight = root.count - root.distance * Math.log(root.count, b)

	children = root.right

	children.each do |c|
		gen_weights_r(c, b)
	end
end

def gen_weights_l(root, b)
	root.weight = root.count - root.distance * Math.log(root.count, b)

	children = root.left

	children.each do |c|
		gen_weights_l(c, b)
	end
end

def displayR(node)
	if node.right != nil
		#puts "Parent(D:" + node.distance.to_s + ", C:" + node.count.to_s + ", W:" + node.weight.to_s + "): " + node.word

		#puts "Children: "
		node.right.each do |r|
			print r.word + " "
		end

		#puts

		node.right.each do |r|
			displayR(r)
		end
	end
end

def sum_right(node)
	f = node.right[0]

	if f == nil then
		return
	end

	(1...node.right.length).each do |n|
		if f.weight < node.right[n].weight then
			f = node.right[n]
		end
	end

	sum_r = sum_right(f)

	return node.word + " " + sum_r.to_s
end

def sum_left(node)
	f = node.left[0]

	if f == nil then
		return
	end

	(1...node.left.length).each do |n|
		if f.weight < node.left[n].weight then
			f = node.left[n]
		end
	end

	if f.weight <= 1 then
		return
	end

	sum_l = sum_left(f)

	return node.word + " " + sum_l.to_s
end

def summarize(tweets, topic_word, b)
	puts "error"
	matching_tweets = []
	alignment = []

	max_r_length = 0
	r_lengths = []
		
	tweets.each do |tweet|
		tokenized = tokenize(tweet)
		idx = 0		

		
			tokenized.each do |token|
				if token == topic_word then
					matching_tweets.append(tweet)
					alignment.append(idx)
						
					r_length = tokenized.length - idx - 1

					r_lengths.append(r_length)

				if max_r_length < r_length then
					max_r_length = r_length
				end
					break
				end 

				idx += 1
			end
		
	end	

	root = WordNode.new(topic_word)
	root.distance = 0

	expand(root, alignment, 1, matching_tweets, 'r')
	expand(root, alignment, 1, matching_tweets, 'l')
	gen_distance_r(root)
	gen_distance_l(root)
	gen_weights_r(root, b)
	gen_weights_l(root, b)

	#displayR(root)
	r_sum = sum_right(root)
	l_sum = sum_left(root)

	rev = ""

	rev_lsum = tokenize(l_sum)
	rev_lsum.reverse!

	(0...rev_lsum.length-1).each do |s|
			if s == rev_lsum.length then
				rev += rev_lsum[s]
			else
				rev += rev_lsum[s] + " "
			end
	end

	if rev.nil? then
		rev = ""
	end

	if r_sum.nil? then
		r_sum = ""
	end	

	return (rev + r_sum).chomp
end