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

	def initialize(words)
		puts "Connecting to Twitter API"

		print "About to configure..."

		TweetStream.configure do |config|
		  config.consumer_key       = 'x'
		  config.consumer_secret    = 'x'
		  config.oauth_token        = 'x'
		  config.oauth_token_secret = 'x'
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

				puts "#{status.text}"

				tweetstring = quote_string(status.text)
				user = status.user.screen_name
				tweet_created_at = status.attrs[:created_at]
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


				ins = @db.prepare("INSERT INTO tweets (tweet_user, tweet_text, tweet_time, tweet_lat, tweet_lon, created_at, updated_at, job_id) VALUES ('#{user}', '#{tweetstring}', '#{server_created_at}', #{lat}, #{lon}, '#{tweet_created_at}', '#{server_created_at}', '#{collection_id}')").execute
				if !@continue then
					@tclient.stop
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
		@tclient.stop
	end
end
