class RedisCacher

  def fetch(url, max_age = 0)
    @redis_cache = REDIS.get(url)

    if @redis_cache
      cached_response = JSON.parse @redis_cache
      time_diff = Time.now - Time.parse(cached_response["time_stamp"])
      return Base64.decode64(cached_response["response"]) if time_diff < max_age
    end

    response = Net::HTTP.get_response(URI.parse(url)).body
    cache = {
      "response" => Base64.encode64(response),
      "time_stamp" => Time.now
    }

    REDIS.set url, cache.to_json
    return response
  end

end
