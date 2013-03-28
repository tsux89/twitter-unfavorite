# -*- encoding: utf-8 -*-

# あんふぁぼをみていたぞ

require 'twitter'
require 'tweetstream'
require 'pp'

# 定義
CONSUMER_KEY = ''
CONSUMER_SECRET = '' 
OAUTH_TOKEN = ''
OAUTH_TOKEN_SECRET = ''

$host = Twitter::Client.new(
  :consumer_key       => CONSUMER_KEY,
  :consumer_secret    => CONSUMER_SECRET,
  :oauth_token        => OAUTH_TOKEN,
  :oauth_token_secret => OAUTH_TOKEN_SECRET
)

TweetStream.configure do |config|
  config.consumer_key       = CONSUMER_KEY
  config.consumer_secret    = CONSUMER_SECRET
  config.oauth_token        = OAUTH_TOKEN
  config.oauth_token_secret = OAUTH_TOKEN_SECRET
  config.auth_method        = :oauth
end

client = TweetStream::Client.new

client.on_event(:unfavorite) do |event|
  
  $host.update("@#{event[:source][:screen_name]} ( ◠‿◠ )☝ あんふぁぼをみていたぞ")
  
  pp event
  puts "===================="
  puts "@#{event[:source][:screen_name]}"
  
  Thread.new{
    f = open("unfavorite.log", "a")
    f.write("\n@#{event[:source][:screen_name]} #{event[:source][:id]} #{Time.now}")
    f.close
  }
  
end
client.userstream do |status|
  puts status.user.screen_name
  puts status.text
end

puts "Connecting to Twitter..."

Thread.new{
  client.userstream
}

#メインスレッドを殺すな
while true
end

#
# もうちょっと速くできそうだけどわからない:;(∩´﹏`∩);:
#