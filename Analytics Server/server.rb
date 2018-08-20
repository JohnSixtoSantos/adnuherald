require 'socket'
require 'sqlite3'
require 'lda-ruby'
require_relative 'summarizer'

PORT   = 8081
DB_PATH = "../db/development.sqlite3"

socket = TCPServer.new('0.0.0.0', PORT)

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

def run_topic_analysis(collection_id, num_topics, num_words)
	puts "Collection ID: " + collection_id.to_s
	puts "Number of Topics: " + num_topics.to_s
	puts "Number of Words: " + num_words.to_s

	db = SQLite3::Database.new DB_PATH

	@tweets = []

	db.execute("SELECT * from tweets WHERE job_id = ?;", collection_id) do |row|
		 @tweets.append(row[1])
	end

	corpus = Lda::Corpus.new

	@tweets.each do |r|
		corpus.add_document(Lda::TextDocument.new(corpus, data_clean(r.to_s)))
	end

	lda = Lda::Lda.new(corpus)
	lda.verbose = false
	lda.num_topics = num_topics

	lda.em("random")

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

	p @topic_mat

	db.close
end

def run_summarization(collection_id, topic_word, bval)
	db = SQLite3::Database.new DB_PATH

	@tweets = []

	db.execute("SELECT * from tweets WHERE job_id = ?;", collection_id) do |row|
	 	@tweets.append(data_clean(row[1]))
	end

	@result = summarize(@tweets, topic_word.downcase, bval)

	p @result.chomp

	db.close
end

puts "Listening on #{PORT}. Press CTRL+C to cancel."

loop do
	client = socket.accept
	job_type = client.gets.chomp

	if job_type == "topic" then
		c_id = client.gets.to_i
		nt = client.gets.to_i
		nw = client.gets.to_i

		Thread.new { run_topic_analysis(c_id, nt, nw) }
	elsif job_type == "summary" then
		collection_id = client.gets.to_i
		topic_word = client.gets
		bval = client.gets.to_f

		Thread.new { run_summarization(collection_id, topic_word.chomp, bval) }
	end
end
