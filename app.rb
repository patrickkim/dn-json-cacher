require "rubygems"
require "sinatra"
require "json"
require "redis"
require "./mem_fetcher"

configure do
  redis_uri = ENV["REDISTOGO_URL"] || 'redis://localhost:6379'
  uri = URI.parse(redis_uri)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get "/" do
  content_type:json
  { response: 200, success: true }.to_json
end

get "/r" do
  cache ||= MemFetcher.new
  api_response = cache.fetch("https://news.layervault.com/?format=json", 300)

  content_type:json
  api_response
end

get "/n" do
  cache ||= MemFetcher.new
  api_response = cache.fetch("https://news.layervault.com/new?format=json", 300)

  content_type:json
  api_response
end
