class MemFetcher

  def fetch(url, max_age = 0)
    #response sets it to nil if key doesnt exist
    @cache = REDIS.get(url)

    if @cache
      cache_response = JSON.parse @cache
      return cache_response["response"] if Time.now - cache_response["time_stamp"] < max_age
    end

    cache = {
      "response" => "{testing: response_test}",
      # Net::HTTP.get_response(URI.parse(url)).body,
      "time_stamp" => Time.now
    }

    REDIS.set url, cache.to_json

    binding.pry
    return cache["response"]
  end

end
