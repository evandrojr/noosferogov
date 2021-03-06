require 'rubygems'
require 'twitter'
require 'iconv'

#disable address resolv to avoid problems with proxy
class Resolv
  def self.getaddress(host)
    host
  end
end

#Filters non-UTF8 octets
def UTF8Filter(string)
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    #Attention please, don't remove + ' ')[0..-2] it is used for UTF8 validation
    ic.iconv(string + ' ')[0..-2]
end

def listen_twitter_stream(hub, author_id)

  connected = false
  tries = 0
  while !connected
    begin
      tries += 1
      client = Twitter::Streaming::Client.new do |config|
        config.consumer_key        = hub.twitter_consumer_key
        config.consumer_secret     = hub.twitter_consumer_secret
        config.access_token        = hub.twitter_access_token
        config.access_token_secret = hub.twitter_access_token_secret
      end
      puts client.inspect
      connected = true
      tries = 0
    rescue => e
      puts "Error connecting to twitter stream: #{e.inspect}"
      sleep (10 + 2 ** tries)
    end
  end

  tries = 0
  while true
    begin
      tries += 1
      client.filter(:track => hub.twitter_hashtags) do |object|
        if object.is_a?(Twitter::Tweet)
          comment = Comment.new
          comment.title = 'hub-message-twitter'
          comment.source = hub
          comment.body = UTF8Filter(object.text)
          comment.profile_picture = object.user.profile_image_url.to_s
          comment.author_id = author_id
          comment.name = UTF8Filter(object.user.screen_name)
          comment.email = 'admin@localhost.local'

          tries = 0
          begin
            comment.save!
          rescue => e
            puts "Error writing twitter comment #{e.inspect}"
          end
        end
      end
    rescue => e
      puts "Error reading twitter stream #{e.inspect}"
      sleep (10 + 2 ** tries)
    end
  end
end
