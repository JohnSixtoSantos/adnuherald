require 'tweetstream'
require 'json'
require 'sqlite3'


ENV['RAILS_ENV'] = "development" # Set to your desired Rails environment name
#require '../config/environment.rb'

class TwitterCollector
	@keywords_set = false
	@keywords = ""
	@continue = true
	@db_host = ""
	@db_port = ""
	@db_database = ""
	@db_username = ""
	@db_password = ""
	@conn = nil
	@db= nil
	@tclient = nil

	def initialize(words)
		puts "Connecting to Twitter API"

		print "About to configure..."

		TweetStream.configure do |config|
		  config.consumer_key       = "LW41uhmQ11gZVSNk854RZHwB8"
		  config.consumer_secret    = "Gc88Sa5pdgpdQZiNHZylhxggWOjEGv4khOLPIxorladTCJF3ON"
		  config.oauth_token        = "2424725288-GGoCuxls4zVFTzkY7uM81SNfZkJw47Ivrojqnct"
		  config.oauth_token_secret = "63tnd2cGc1b7d1DosKbUUBpLCW9p9TNpwo11lkVN96wmY"
		  config.auth_method        = :oauth
		end

		puts "done!"

		dbConnect()
		setTrackingKeywords(words)
	end

	def setTrackingKeywords(words)
		print "Setting keywords: [" + words

		@keywords = words

		puts "]...done!"

		@keywords_set = true
	end

	def dbConnect()
		print 'About to connect to the database...'

		#@conn = PGconn.connect(:host=>@db_host, :port=>@db_port, :dbname=>@db_database, :user=>@db_username, :password=>@db_password)

		@db = SQLite3::Database.new "../db/development.sqlite3"

		puts 'done!'
	end 

	def stopTracking()
		@continue = false
		@tclient.stop
	end

	def herp
		@db.execute(
			"INSERT INTO tweets (tweet_user, tweet_text, tweet_time, tweet_lat, tweet_lon, created_at, updated_at) VALUES ('DERP', 'DERP', '#DERP', 1, 1, 0, 0)"
		)
	end

	def startTracking(collection_id)
		if @keywords_set then
			print "About to connect to Twitter Stream..."

			@continue = true

			@tclient = TweetStream::Client.new

			@tclient.on_error do |message|
				puts message
			end 

			flag = false

			@tclient.track(@keywords) do |status|
				if !flag then
					print "done!\nStarting Tweet colletion...\n"
					print "Keywords used: " + @keywords + "\n"
					flag = true
				end

				#puts "#{status.text}"

				t_time = status.attrs[:created_at].split(" ")

				mon_dict = {}
				mon_dict["Jan"] = "01"
				mon_dict["Feb"] = "02"
				mon_dict["Mar"] = "03"
				mon_dict["Apr"] = "04"
				mon_dict["May"] = "05"
				mon_dict["Jun"] = "06"
				mon_dict["Jul"] = "07"
				mon_dict["Aug"] = "08"
				mon_dict["Sep"] = "09"
				mon_dict["Oct"] = "10"
				mon_dict["Nov"] = "11"
				mon_dict["Dec"] = "12"

				tweetstring = ""

				if status.attrs[:extended_tweet].nil? then
					tweetstring = quote_string(status.text)
				else
					tweetstring = quote_string(status.attrs[:extended_tweet][:full_text])
				end

				if !status.attrs[:retweeted_status].nil? && !status.attrs[:retweeted_status][:extended_tweet].nil? then
					tweetstring = tweetstring + " $$$$$***** " + status.attrs[:retweeted_status][:extended_tweet][:full_text]

					#split handler
					s = tweetstring.split("$$$$$*****") #split retweet text (left) and original tweet (on the right)
	
					t = "" #accumulator for the string 

					if s.length > 1 then #if s.length is > 1 then there is a retweet portion of the tweet otherwise it is an original tweet
										#remember to count how many times this happends
						t = s[1] #s[0] is the original, s[1] is the retweet text
								
						names = s[0].split(" ") #split original tweet by blank text

						t = names[0] + " " + names[1] + " " + t #append the RT info to the full length retweet source tweet
					else
						t = s[0]	#if there is no retweet part, then ignore the retweet portion of the string 
					end

					t.chomp.gsub(/\s+/, " ")
					#split handler

					tweetstring = t

					tweetstring = quote_string(tweetstring)

					puts status.attrs[:retweeted_status][:extended_tweet][:full_text]
				end

				puts status.attrs[:user][:location]

				user = status.user.screen_name
				tweet_created_at = t_time[5] + "-" + mon_dict[t_time[1]] + "-" + t_time[2] + " " + t_time[3]			
				server_created_at = Time.now

				#t = Tweet.new
				#t.tweet_text = tweetstring

				if status.attrs[:coordinates].nil? then
					lat = 'NULL'
					lon = 'NULL'

					#t.tweet_lat = ""
					#t.tweet_lon = ""
				else	
					lat = status.attrs[:coordinates][:coordinates].last
					lon = status.attrs[:coordinates][:coordinates].first

					#t.tweet_lat = lat
					#t.tweet_lon = lon
				end

				#t.tweet_user = user
				#t.tweet_time = tweet_created_at
				#t.job_id = collection_id

				#t.save

				#insertTweet(tweetstring, lat, lon, user, tweet_created_at, collection_id)

				ins = @db.prepare("INSERT INTO tweets (tweet_user, tweet_text, tweet_time, tweet_lat, tweet_lon, created_at, updated_at, job_id) VALUES ('#{user}', '#{tweetstring}', '#{tweet_created_at}', #{lat}, #{lon}, strftime(\'%Y-%m-%d %H:%M:%S\',\'now\'), strftime(\'%Y-%m-%d %H:%M:%S\',\'now\'), '#{collection_id}')").execute
				
				if !@continue then
					@tclient.stop
					p "Shutting down collection..."
					break
				end
			end
		else
			puts "Keywords not set. Unable to start tracking."
		end
	end

	def quote_string(s)
		s.gsub(/\\/, '\&\&').gsub(/'/, "''") # ' (for ruby-mode)
	end

	def closeTwitterClient()
		@continue = false
		@tclient.stop
	end
end
