# -*- encoding: utf-8 -*-

# あんふぁぼをみていたぞ

require 'twitter'
require 'tweetstream'
require 'pp'

# 定義
CONSUMER_KEY = 'Z4OYJ9MYorsl9UtQzh2Eg'
CONSUMER_SECRET = 'gnLMD0GFd6Ktzyn7judX8OHcXVFnMCpMYDCK1NPro'

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
  
  #自分があんふぁぼ[した]ときに通知が飛んでくるのを防ぐ
  if event[:target][:screen_name] =~ /k534[2345]/ then
    $host.update("@#{event[:source][:screen_name]} ( ◠‿◠ )☝ あんふぁぼをみていたぞ")
  end
  
  pp event
  puts "===================="
  puts "@#{event[:source][:screen_name]}"
  
  Thread.new{
    f = open("unfavorite.log", "a")
    f.write("\n@#{event[:source][:screen_name]} #{event[:source][:id]} #{Time.now}")
    f.close
  }
  
end

#繋げてるかまあ様子見程度でストリーミング表示する
client.userstream do |status|
  puts status.user.screen_name
  puts status.text
end

stream = Thread.new{
  client.userstream
}

#メインスレッドを殺すな(EventMachine使ったほうが無駄なリソース喰わなくていいらしい)
stream.join

#
# もうちょっと速くできそうだけどわからない:;(∩´﹏`∩);:
#
