require "net/http"
require "cache"

class MemFetcher
  def initialize
    @cache = {}
  end

  def fetch(url, max_age=0)
    if @cache.has_key? url
      puts "exists in cache"
      return @cache[url][1] if Time.now-@cache[url][0] < max_age
    end
    
    response = Net::HTTP.get_response(URI.parse(url)).body
    @cache[url] = [Time.now, response]
    return @cache[url][1]
  end
end
