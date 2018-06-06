module Crawler
  class Config
    # base for difficulty checks
    BASE = 10

    def self.settings
      { base: BASE }.freeze
    end
  end
end
