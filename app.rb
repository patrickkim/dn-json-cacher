require "net/http"
require "base64"
require "json"
require "redis"
require "sinatra"
require_relative "redis_cacher"

configure do
  redis_uri = ENV["REDISTOGO_URL"] || 'redis://localhost:6379'
  uri = URI.parse(redis_uri)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  REDIS_CACHER = RedisCacher.new
  MAX_AGE = 300
end

get "/" do
  content_type:json
  { response: 200, success: true }.to_json
end

get "/r" do
  @api_response = REDIS_CACHER.fetch "https://news.layervault.com/?format=json", MAX_AGE

  content_type:json
  @api_response
end

get "/n" do
  @api_response = REDIS_CACHER.fetch "https://news.layervault.com/new?format=json", MAX_AGE

  content_type:json
  @api_response
end
