module Crawler
  class Creature
    attr_accessor :name, :hp, :xp, :level, :loot

    def initialize(attrs = {})
      @name = attrs[:name] || generate_name
      @hp = attrs[:hp] || 1
      @xp = attrs[:xp] || 0
      @level = attrs[:level] || 0
      @loot = attrs[:loot] || {}
    end

    def definite_name
      "A #{name.downcase}"
    end

    private

    # override by child class
    def generate_name
      self.class.name.split("::").last
    end
  end
end
