class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login

  	def require_login
  		if session[:user_id].nil? then 
  			redirect_to "/"
  		end
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


end
