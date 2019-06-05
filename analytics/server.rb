require 'socket'
require 'lda-ruby'
require 'liblinear'
require_relative 'summarizer'
require "rgl/adjacency"
require "rgl/dot"
require_relative 'Node'
require_relative 'Word'
require_relative 'twitter_collector'

#CONFIG
ENV['RAILS_ENV'] = "development" # Set to your desired Rails environment name
require '../config/environment.rb'

PORT = 8081

socket = TCPServer.new('0.0.0.0', PORT)
#CONFIG

def unique_words(mat)
		words = []

		mat.each do |row|
			row.each do |item|
				words.append(item)
			end
		end

		words = words.uniq

		counts = {}

		words.each do |word|
			counts[word] = 0
		end

		mat.each do |row|
			row.each do |item|
				counts[item] += 1
			end
		end	

		new_mat = []

		mat.each do |row|

			temp_row = []

			row.each do |item|
				if counts[item] == 1 then
					#copy to new mat
					temp_row.append(item)
				end
			end

			new_mat.append(temp_row)
		end

		return new_mat
	end

def data_clean(s)
	#remove UTF
	#remove stopwords c
	#remove urls c
	#remove non-alpha c
	#remove rt c

	@stopwords = [
		"a",
		"about",
		"above",
		"after",
		"again",
		"against",
		"aking",
		"ako",
		"ala",
		"alin",
		"all",
		"am",
		"amin",
		"aming",
		"an",
		"and",
		"andun",
		"ang",
		"ano",
		"any",
		"are",
		"arent",
		"as",
		"at",
		"ata",
		"atin",
		"atin ",
		"ating",
		"ay",
		"ayan",
		"ayaw",
		"ayun",
		"b",
		"ba",
		"baba",
		"bago",
		"bakit",
		"bang",
		"bawat",
		"be",
		"because",
		"been",
		"before",
		"being",
		"below",
		"between",
		"both",
		"buhay",
		"bukas",
		"but",
		"by",
		"c",
		"can",
		"cannot",
		"cant",
		"could",
		"couldnt",
		"d",
		"dagdag",
		"dagdagan",
		"dahil",
		"dapat",
		"datapwat",
		"daw",
		"de",
		"di",
		"did",
		"didnt",
		"din",
		"dito",
		"do",
		"does",
		"doesnt",
		"doing",
		"dont",
		"doon",
		"down",
		"during",
		"dyan",
		"e",
		"each",
		"eh",
		"el",
		"f",
		"few",
		"for",
		"from",
		"further",
		"g",
		"gagawin",
		"galing",
		"gawa",
		"gawin",
		"gaya",
		"ginagawa",
		"ginawa",
		"gitna",
		"go",
		"h",
		"ha",
		"habang",
		"had",
		"hadnt",
		"haha",
		"halika",
		"halikayo",
		"hanggang",
		"has",
		"hasnt",
		"have",
		"havent",
		"having",
		"he",
		"hed",
		"hell",
		"her",
		"here",
		"heres",
		"hers",
		"herself",
		"hes",
		"him",
		"himself",
		"hindi",
		"hindi ",
		"his",
		"how",
		"hows",
		"huwag",
		"i",
		"iba",
		"ibaba",
		"ibabaw",
		"id",
		"if",
		"ikaw",
		"ilalim",
		"ill",
		"im",
		"in",
		"into",
		"inyong",
		"is",
		"isang",
		"isnt",
		"it",
		"itaas",
		"ito",
		"its",
		"itself",
		"ive",
		"iyan",
		"iyo",
		"iyon",
		"iyong",
		"iyun",
		"j",
		"k",
		"ka",
		"kahit",
		"kailan",
		"kami",
		"kang",
		"kanila",
		"kanilang",
		"kanino",
		"kanya",
		"kanyang",
		"kapag",
		"kapang",
		"kapiranggot",
		"karagdagan",
		"kasama",
		"kasi",
		"kaunti",
		"kay",
		"kaya",
		"kayo",
		"kaysa",
		"kelan",
		"kesa",
		"ko",
		"kung",
		"l",
		"la",
		"laban",
		"labas",
		"lahat",
		"lamang",
		"lang",
		"lets",
		"loob",
		"los",
		"m",
		"maaari",
		"maaaring",
		"maaring",
		"mag",
		"maging",
		"mang",
		"mangilan",
		"may",
		"mayroon",
		"me",
		"meron",
		"mga",
		"minsan",
		"mismo",
		"mo",
		"more",
		"most",
		"muli",
		"mustnt",
		"my",
		"myself",
		"n",
		"na",
		"nag",
		"nagawa",
		"nagkaroon",
		"nais",
		"naman",
		"nandito",
		"nandoon",
		"nang",
		"nanggaling",
		"napaka",
		"narito",
		"nasaan",
		"nasan",
		"ng",
		"nga",
		"ngunit",
		"ni",
		"nilalang",
		"nito",
		"niya",
		"no",
		"nor",
		"not",
		"nung",
		"nya",
		"o",
		"of",
		"off",
		"oh",
		"on",
		"once",
		"only",
		"oo",
		"or",
		"other",
		"ought",
		"our",
		"ours",
		"ourselves",
		"out",
		"over",
		"own",
		"p",
		"pa",
		"paano",
		"paanong",
		"pag",
		"paggawa",
		"pagitan",
		"pagkakaroon",
		"pagkatapos",
		"pala",
		"palang",
		"pamamagitan",
		"pang",
		"pano",
		"papaanong",
		"para",
		"parehas",
		"pareho",
		"patas",
		"patay",
		"pati",
		"pero",
		"pinaka",
		"pinanggalingan",
		"po",
		"pwede",
		"q",
		"r",
		"rin",
		"rt",
		"s",
		"sa",
		"saan",
		"saka",
		"same",
		"san",
		"sana",
		"sarado ",
		"sarili",
		"shant",
		"she",
		"shed",
		"shell",
		"shes",
		"should",
		"shouldnt",
		"si",
		"sila",
		"sino",
		"siya",
		"so",
		"some",
		"subalit",
		"such",
		"t",
		"taas",
		"tapos",
		"than",
		"that",
		"thats",
		"the",
		"their",
		"theirs",
		"them",
		"themselves",
		"then",
		"there",
		"theres",
		"these",
		"they",
		"theyd",
		"theyll",
		"theyre",
		"theyve",
		"this",
		"those",
		"through",
		"to",
		"too",
		"tulad",
		"tungkol",
		"u",
		"under",
		"ung",
		"until",
		"up",
		"v",
		"very",
		"via",
		"w",
		"wala",
		"was",
		"wasnt",
		"we",
		"wed",
		"well",
		"were",
		"werent",
		"weve",
		"what",
		"whats",
		"when",
		"whens",
		"where",
		"wheres",
		"which",
		"while",
		"who",
		"whom",
		"whos",
		"why",
		"whys",
		"with",
		"wont",
		"would",
		"wouldnt",
		"x",
		"y",
		"yan",
		"yang",
		"yata",
		"you",
		"youd",
		"youll",
		"your",
		"youre",
		"yours",
		"yourself",
		"yourselves",
		"youve",
		"yung",
		"z"
	]

	s = s.downcase

	splits = s.split(' ')
	
	buffer = ""
	i = 0

	stopwords = []

	@stopwords.each do |f|
		f.each_line do |el|
			stopwords.append(el)
		end  		
	end

	splits.each do |sp|	
		found = false

		stopwords.each do |sw|
			
			if sp.chomp == sw.chomp then
				found = true
			end
		end

		if found == false then
			if i == 0 then
				buffer += sp
				i = 1
			else
				buffer += " " + sp
			end
		end
	end

	s = buffer
	
	s = s.gsub(/(?:f|ht)tps?:\/[^\s]+/, '') #remove url
	
	s = s.gsub(/[^0-9a-z ]/i, '') #removes non-alpha
	
	return s
end

def stringarr_to_vector(s)
	dict = Hash.new
	words = []
		
	s.each do |r|
		b = r.tweet_text.split(' ')

		b.each do |bw|
			words.append(bw)
		end
	end

	uniques = words.uniq.sort
	ulen = uniques.length

	ctr = 0
	uniques.each do |u|
		dict[u] = ctr
		ctr += 1
	end

	dataset = []
		
	s.each do |r|
		bow = Array.new(ulen, 0)

	    b = r.tweet_text.split(' ')
	    b.each do |bw|
		    bow[dict[bw]] = 1 
		end

		dataset.append(bow)
	end

	return dataset
end

def run_sentiment_analysis(label_set_id)
	@label_set_id = label_set_id

	@collection_id = LabelSet.find(@label_set_id).collection_id

	@testing_set = []
	@training_set = []
	@testing_set_ids = []
	@raw_tweets = Tweet.where(job_id: @collection_id)
	labels = []

	@raw_tweets.each do |t|
		@temp_label = Label.where(label_set_id: @label_set_id).where(tweet_id: t.id)
		if @temp_label[0].nil? then
			ntweet = Tweet.find(t.id)
			@testing_set.append(ntweet)
			@testing_set_ids.append(t.id)
		else
			ntweet = Tweet.find(t.id)
			@training_set.append(ntweet)
			labels.append(@temp_label[0].label)
		end
	end			

	@train_tweets = stringarr_to_vector(@training_set)
	@test_tweets = stringarr_to_vector(@testing_set)

	model = Liblinear.train(
		{ solver_type: Liblinear::L2R_L2LOSS_SVC  },   # parameter
		 labels,                       # labels (classes) of training data
		 @train_tweets # training data
	)

	i = 0
	matches = 0

	@pred = []
	@marks = []
	@heat = []

	@test_tweets.each do |data|
		pr = Liblinear.predict(model, data)
		@pred.append(pr)
	end

	@sent_lab_set = SentimentLabelSet.new
	@sent_lab_set.collection_id = @collection_id
	@sent_lab_set.label_set_id = @label_set_id

	@sent_lab_set.save

	i = 0

	@pred.each do |pr|
		@lab = Sentiment.new
		@lab.tweet_id = @testing_set_ids[i]
		@lab.polarity = pr
		@lab.sentiment_label_set_id = @sent_lab_set.id

		@lab.save

		i += 1
	end

	@message = Notification.new
	@message.message = "Sentiment Analysis Complete!"
	@message.is_read = false
	@message.message_type = "analytics"
	@message.link = "/sentiment/analyses/results/" + @sent_lab_set.id.to_s

	@message.save
end	

def run_topic_analysis(collection_id, num_topics, num_words, description)
	puts "Collection ID: " + collection_id.to_s
	puts "Number of Topics: " + num_topics.to_s
	puts "Number of Words: " + num_words.to_s

	@tweets = Tweet.where(job_id: collection_id)

	corpus = Lda::Corpus.new

	@tweets.each do |r|
		tx = data_clean(r.tweet_text.to_s)

		if tx != "" then
			corpus.add_document(Lda::TextDocument.new(corpus, tx))
		end
	end

	lda = Lda::Lda.new(corpus)
	lda.verbose = false
	lda.num_topics = num_topics

	lda.em("random")
	p "EM Convergence: "
	p lda.em_convergence

	topics = lda.top_words(num_words)

	@topic_mat = []

	(0...num_topics).each do |i|
		temp = []

		topics[i].each do |word|
			temp.push(word)
		end

		@topic_mat.push(temp)
	end

	@topic_mat = unique_words(@topic_mat)

	@n_topic_results = TopicAnalysisResult.new
	@n_topic_results.description = description
	@n_topic_results.num_topics = num_topics
	@n_topic_results.num_words = num_words
	@n_topic_results.collection_id = collection_id
	@n_topic_results.save

	i = 0
	
	@topic_mat.each do |row|
		j = 0

		@topc = Topic.new
		@topc.topic_number = i
		@topc.topic_result_id = @n_topic_results.id
		@topc.save

		row.each do |item|
			new_word = TopicWord.new

			new_word.word_text = item
			new_word.order_number = j
			new_word.topic_id = @topc.id
			new_word.save

			j += 1
		end
		i += 1
	end

	@topic_mat = unique_words(@topic_mat)

	p @topic_mat

	@message = Notification.new
	@message.message = "Topic Analysis Complete!"
	@message.is_read = false
	@message.message_type = "analytics"
	@message.link = "/topic/analyses/results/" + @n_topic_results.id.to_s

	@message.save
end

def run_summarization(collection_id, topic_word, bval)
	puts "Collection ID: " + collection_id.to_s
	puts "Topic Word: " + topic_word.to_s
	puts "b-Value: " + bval.to_s

	@raw_tweets = Tweet.where(job_id: collection_id)
	@tweets = []

	@raw_tweets.each do |t|
		t = data_clean(t.tweet_text)
		if t != "" then
			@tweets.append(t)
		end
	end

	@result = summarize(@tweets, topic_word.downcase, bval)

	p @result.chomp
	
	@n_result = SummarizationResult.new
	@n_result.root_word = topic_word
	@n_result.b_value = bval
	@n_result.summary = @result
	@n_result.collection_id = collection_id
	@n_result.save

	@message = Notification.new
	@message.message = "Summarization Complete!"
	@message.is_read = false
	@message.message_type = "analytics"
	@message.link = "/summary/analyses/" + collection_id.to_s

	@message.save
end

def run_centrality(collection_id) #for implementation
	@tweets = Tweet.where(job_id: collection_id)
	@usernames = []
	@nodes = []
	@edges = []
	
	@tweets.each do |tweet|
		@usernames.append(tweet.tweet_user.downcase)
	end

	@usernames = @usernames.uniq
	
	@user_hash = {}

	@usernames.each do |u|
		uclean = data_clean(u)
		@user_hash[uclean] = 0
		n = Node.new
		n.id = uclean
		n.label = uclean
		n.size  = 0
		n.x = rand(1000)
		n.y = rand(1000)

		@nodes.append(n)
	end

	@tweets.each do |tweet|
		i = 0

		(0...@usernames.length).each do |i|
			clean_username = data_clean(@usernames[i])

			if data_clean(tweet.tweet_text).include? clean_username then
				@user_hash[clean_username] += 1
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

	#Degree Centrality 
	graph = RGL::DirectedAdjacencyGraph.new

	@user_hash.each do |k, v|
		graph.add_vertices(k)
	end

	edge_weights = {}
	@in_degrees = {}

	@tweets.each do |tweet|
		i = 0

		@user_hash.each do |k,v|
			if data_clean(tweet.tweet_text).include? k then
				arg_edge = [data_clean(tweet.tweet_user), k]
				if edge_weights[arg_edge].nil? then
					edge_weights[arg_edge] = 1
				else
					edge_weights[arg_edge] += 1
				end

				if @in_degrees[k].nil? then #ERROR NODE SIZE IS MENTION SIZE NOT DEGREE
					@in_degrees[k] = 1
				else
					@in_degrees[k] += 1
				end
			end
		end
	end

	edge_weights.each { |(city1, city2), w| graph.add_edge(city1, city2) }

	@t_results = CentralityResultSet.new
	@t_results.description = ""
	@t_results.collection_id = collection_id
	@t_results.save

	i = 0
	edge_weights.each do |(s, d), w|

		# n = Edge.new
		# n.id = "e" + i.to_s
		# n.source = s
		# n.target = d
		# n.size = 1
		# n.color = "#ccc"
		# @edges.append(n)

		@t_edge = CentralityEdge.new
		@t_edge.edge_number = "e" + i.to_s
		@t_edge.source = s
		@t_edge.target = d
		@t_edge.size = 1
		@t_edge.color = "#ccc"
		@t_edge.centrality_result_set_id = @t_results.id

		@t_edge.save

		i += 1
	end

	@nodes.each do |n|
		n.size = 1

		@in_degrees.each do |k, v|
			if k == n.label then
				n.size = v
				break
			end
		end
	end

	@nodes.each do |n|
		@t_node = CentralityNode.new
		@t_node.label = n.label
		@t_node.size = n.size
		@t_node.x_pos = n.x
		@t_node.y_pos = n.y
		@t_node.centrality_result_set_id = @t_results.id

		@t_node.save
	end	

	@user_hash.each do |k,v|
		@t_uhash = CentralityUserHash.new
		@t_uhash.text = k
		@t_uhash.weight = v
		@t_uhash.centrality_result_set_id = @t_results.id

		@t_uhash.save
	end

	@message = Notification.new
	@message.message = "Centrality Analysis Complete!"
	@message.is_read = false
	@message.message_type = "analytics"
	@message.link = "/centrality/analyses/results/" + @t_results.id.to_s

	@message.save
end

def start_collection(collection_id, collector)
	collector.startTracking(collection_id)
end

def stop_collection(collector)
	collector.stopTracking()
end

puts "ADNU-Herald Analytics Server v0.5"

loop do
	puts "Waiting for a connection on port #{PORT}..."

	client = socket.accept
	collector = nil

	puts "Connection successful on #{PORT}. Press CTRL+C to cancel."

	job_type = client.gets.chomp

	if job_type == "topic" then
		c_id = client.gets.to_i
		nt = client.gets.to_i
		nw = client.gets.to_i
		desc = client.gets

		p "Running Topic Analysis"

		#Thread.new { run_topic_analysis(c_id, nt, nw, desc) }
		fork { run_topic_analysis(c_id, nt, nw, desc) }
	elsif job_type == "summary" then
		collection_id = client.gets.to_i
		topic_word = client.gets
		bval = client.gets.to_f
		
		p "Running Summarization"

		#Thread.new { run_summarization(collection_id, topic_word.chomp, bval) }
		fork { run_summarization(collection_id, topic_word.chomp, bval) }
	elsif job_type == "sentiment" then
		label_set_id = client.gets.to_i

		p "Running Sentiment Analysis"

		#Thread.new { run_sentiment_analysis(label_set_id) }
		fork { run_sentiment_analysis(label_set_id) }
	elsif job_type == "centrality" then
		collection_id = client.gets.to_i

		p "Running Centrality Analysis"

		#Thread.new { run_centrality(collection_id) } #for implementation	
		fork { run_centrality(collection_id) }
	elsif job_type == "start_collection" then
		collection_id = client.gets.to_i
		keywords = client.gets.to_s

		collector = TwitterCollector.new(keywords)

		p "Starting Collection"		

		Thread.new { start_collection(collection_id, collector) }	
	elsif job_type == "stop_collection" then

		p "Stopping Collection"		

		if !collector.nil? then
			Thread.new { stop_collection(collector) }	
			p "Collection Stopped"
		end
	end
end
