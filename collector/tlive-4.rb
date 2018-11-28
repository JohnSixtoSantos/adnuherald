require 'tweetstream'
require 'pg'
require 'rubygems'
require 'json'

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

	def initialize()
		

		print "Loading database configuration file..."

		File.open("configuration", "r").each_line do |line|
			data = line.split(": ")
	
			if data[0] == "host" then
				@db_host = data[1].strip
			elsif data[0] == "database" then
				@db_database = data[1].strip
			elsif data[0] == "username" then
				@db_username = data[1].strip
			elsif data[0] == "password" then
				@db_password = data[1].strip
			elsif data[0] == "port" then
				@db_port = data[1].strip
			end
		end

		puts "done!"

		print "About to configure..."

		TweetStream.configure do |config|
		  config.consumer_key       = 'c7YK8vmVMETop5zVYzdNqTlMl'
		  config.consumer_secret    = 'eEkJo4NkDkt1EjNi5JlYZLJIUpugR3KvRcxkvRkG3XFT5Ik7NM'
		  config.oauth_token        = '149349548-WqOz27Kc49h5ucwb5f0qshLmqcuodKpHgH0sRh7O'
		  config.oauth_token_secret = 'Wm730BW8Xy5aMqI4Ggg98nGlJGiHjGBqiQjbQXPr77BBR'
		  config.auth_method        = :oauth
		end

		puts "done!"

		dbConnect()
		setTrackingKeywords()

	end

	def setTrackingKeywords()
		print "Retrieving keyword tracking list..."
        
        res = @conn.exec("SELECT * FROM keywords")

		@keywords = ""

		res = @conn.exec("SELECT key FROM keyword")

		res.each{ |row|
		    @keywords = @keywords + row["key"] + ","
		}

		@keywords.slice!(-1)

		puts "done!"

		@keywords_set = true
	end

	def dbConnect()
		print 'About to connect to the database...'

		@conn = PGconn.connect(:host=>@db_host, :port=>@db_port, :dbname=>@db_database, :user=>@db_username, :password=>@db_password)

		puts 'done!'
	end 

	def stopTracking()
		@continue = false
	end

	def startTracking()
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

				tweetstring = @conn.escape_string(status.text)
				user = status.user.screen_name
				created_at = status.attrs[:created_at]
				tweet_created_at = Time.now

				if status.attrs[:coordinates].nil? then
					lat = 'NULL'
					lon = 'NULL'
				else	
					lat = status.attrs[:coordinates][:coordinates].last
					lon = status.attrs[:coordinates][:coordinates].first
				end

				res = @conn.exec("INSERT INTO tweets (tweet_user, tweet_text, tweet_time, tweet_lat, tweet_lon, created_at, updated_at) VALUES ('#{user}', '#{tweetstring}', '#{created_at}', #{lat}, #{lon}, '#{tweet_created_at}', '#{created_at}')")
		
				if !@continue then
					break
				end
			end
		else
			puts "Keywords not set. Unable to start tracking."
		end
	end

	def closeTwitterClient()
		@tclient.stop
	end
end
