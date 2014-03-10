require "sinatra"
require "json"
require "mem_fetcher"

get "/" do
  content_type:json
  {response: 200, success: true}.to_json
end

get "/r" do
  fetcher = MemFetcher.new
  api_response = fetcher.fetch("https://news.layervault.com/?format=json", 300)

  content_type:json
  api_response
end

get "/n" do
  fetcher = MemFetcher.new
  api_response = fetcher.fetch("https://news.layervault.com/new?format=json", 300)

  content_type:json
  api_response
end
