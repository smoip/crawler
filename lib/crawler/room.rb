module Crawler
  class Room
    include Crawler::Errors

    attr_accessor :name, :outlets, :occupants, :loot, :features

    # can be extended for up/down eventually
    VALID_OUTLETS = [
      :north,
      :south,
      :east,
      :west,
    ].freeze

    def initialize(attrs = {})
      @name = attrs[:name] || generate_name
      @outlets = attrs[:outlets] || []
      validate_outlets
      @occupants = attrs[:occupants] || []
      @loot = attrs[:loot] || []
      @features = attrs[:features] || []
    end

    def description
      # this should be a computed value based on type, features, etc.
    end

    private

    # override for different naming rules
    def generate_name
      self.class.name.split("::").last
    end

    def validate_outlets
      outlets.each do |outlet|
        next if valid_outlet?(outlet)
        raise Crawler::Errors::RoomError.new("Invalid outlet: #{outlet}")
      end
    end

    # extend for room to room connections
    # once that exists
    def valid_outlet?(outlet)
      VALID_OUTLETS.include?(outlet)
    end
  end
end
