require "rubygems"
require "json"
require "redis"

class MemFetcher

  def fetch(url, max_age = 0)
    #response sets it to nil if key doesnt exist
    @redis_cache = REDIS.get(url)

    if @redis_cache
      cached_response = JSON.parse @redis_cache
      time_diff = Time.now - Time.parse cached_response["time_stamp"]
      return cached_response["response"] if time_diff < max_age
    end

    cache = {
      "response" => Net::HTTP.get_response(URI.parse(url)).body,
      "time_stamp" => Time.now
    }

    REDIS.set url, cache.to_json
    return cache["response"]
  end

end
