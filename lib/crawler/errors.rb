module Crawler
  module Errors
    class CrawlerError < StandardError; end

    class CreatureError < CrawlerError; end

    class RoomError < CrawlerError; end
  end
end
