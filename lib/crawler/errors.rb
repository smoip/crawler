module Crawler
  module Errors
    class CrawlerError < StandardError; end

    class CreatureError < CrawlerError; end
  end
end
