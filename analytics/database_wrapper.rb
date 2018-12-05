

def insertTweet(text, lat, lon, user, tweet_time)
	require '../config/environment.rb'
	
	t = Tweet.new
	t.tweet_text = tweetstring
	t.tweet_lat = ""
	t.tweet_lon = ""
	t.tweet_user = user
	t.tweet_time = tweet_created_at
	t.job_id = collection_id

	t.save
end