require "net/http"
require "base64"
require "json"
require "redis"
require "sinatra"

configure do
  redis_uri = ENV["REDISTOGO_URL"] || 'redis://localhost:6379'
  uri = URI.parse(redis_uri)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  MAX_AGE = 300
end

get "/" do
  content_type:json
  { response: 200, success: true }.to_json
end

get "/r" do
  url = "https://news.layervault.com/?format=json"

  @redis_cache = REDIS.get(url)
  if @redis_cache
    cached_response = JSON.parse @redis_cache
    time_diff = Time.now - Time.parse(cached_response["time_stamp"])
    @api_response = Base64.decode64(cached_response["response"])
    REDIS.del(url) if time_diff < MAX_AGE
  else
    raw_response = Net::HTTP.get_response(URI.parse(url)).body
    cache = {
      "response" => Base64.encode64(raw_response),
      "time_stamp" => Time.now
    }

    REDIS.set url, cache.to_json
    @api_response = raw_response
  end

  content_type:json
  @api_response
end

get "/n" do
  url= "https://news.layervault.com/new?format=json"

  @redis_cache = REDIS.get(url)
  if @redis_cache
    cached_response = JSON.parse @redis_cache
    time_diff = Time.now - Time.parse(cached_response["time_stamp"])
    @api_response = Base64.decode64(cached_response["response"])
    REDIS.del(url) if time_diff < MAX_AGE
  else
    raw_response = Net::HTTP.get_response(URI.parse(url)).body
    cache = {
      "response" => Base64.encode64(raw_response),
      "time_stamp" => Time.now
    }

    REDIS.set url, cache.to_json
    @api_response = raw_response
  end

  content_type:json
  @api_response
end
